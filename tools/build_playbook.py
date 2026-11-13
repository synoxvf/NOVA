"""Validate NOVA and build an encrypted AME archive without running its actions.

Requires py7zr and PyYAML (or the isolated copies in .work/python-deps).
"""
from pathlib import Path
import hashlib
import re
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
import py7zr
import yaml


class PlaybookLoader(yaml.SafeLoader):
    pass


def action(loader, suffix, node):
    data = loader.construct_mapping(node, deep=True)
    data['_action'] = suffix.rstrip(':')
    return data


PlaybookLoader.add_multi_constructor('!', action)
src = ROOT / 'src'
config = ET.parse(src / 'playbook.conf').getroot()
features = {n.text for n in config.findall('./FeaturePages//Name')}
for name in ('uninstall-edge', 'install-software', 'uninstall-xbox', 'disable-gamebar', 'disable-bitlocker', 'disable-hibernation'):
    option = next(n for n in config.findall('./FeaturePages//CheckboxOption') if n.findtext('Name') == name)
    assert option.get('IsChecked') == 'true', f'{name} must stay checked by default'
for name in ('disable-windows-updates', 'disable-ntfs-compression'):
    option = next(n for n in config.findall('./FeaturePages//CheckboxOption') if n.findtext('Name') == name)
    assert option.get('IsChecked') == 'false', f'{name} must be opt-in'
for icon in config.findall('./Software/Package/Icon'):
    assert (src / 'Images' / icon.text).is_file(), f'Missing icon {icon.text}'

actions = []
for path in (src / 'Configuration').rglob('*.yml'):
    task = yaml.load(path.read_text(encoding='utf-8-sig'), Loader=PlaybookLoader)
    assert isinstance(task.get('actions'), list), path
    for item in task['actions']:
        kind = item.get('_action')
        assert kind != 'appx', f'Forced AppX action: {path}'
        for option in [item.get('option')] + item.get('options', []):
            if option:
                assert option.lstrip('!') in features, f'Unknown option {option} in {path}'
        if kind == 'task':
            assert (src / 'Configuration' / item['path'].replace('\\', '/')).is_file(), item
        if kind == 'powerShell' and item.get('exeDir'):
            for script in re.findall(r'\.\\([A-Za-z0-9_-]+\.ps1)', item['command']):
                assert (src / 'Executables' / script).is_file(), f'Missing script {script}'
        actions.append(item)

store = [a for a in actions if a.get('value') == 'AutoDownload']
assert len(store) == 1 and str(store[0]['data']) == '4'
assert any(a.get('args') == 'behavior set disablecompression 0' and a.get('option') == '!disable-ntfs-compression' for a in actions)
wake = [a for a in actions if '\\InstallService\\WakeUp' in a.get('path', '')]
assert len(wake) == 2 and all(a['operation'] == 'enable' for a in wake)
for a in actions:
    assert 'ResetBase' not in a.get('args', '')
    if a.get('value', '').startswith('Pause') and a.get('operation') != 'delete':
        assert a.get('option') == 'disable-windows-updates'
    if a.get('_action') in ('file', 'registryKey', 'service', 'taskKill'):
        target = (a.get('path', '') + a.get('name', '')).lower()
        assert not any(s in target for s in ('edgewebview', 'edgeupdate', 'msedgewebview2'))

cleaner = (src / 'Executables/CLEANER.ps1').read_text()
assert all(s not in cleaner for s in ('wevtutil', 'SoftwareDistribution', 'Stop-Service', 'Delete-DeliveryOptimizationCache'))
gamebar = (src / 'Executables/GAMEBAR.ps1').read_text()
assert 'Remove-Item' not in gamebar and 'APPX.ps1' in gamebar
print(f'PASS: XML, YAML, options, references and compatibility checks ({len(actions)} actions)')

out = ROOT / 'dist/NOVA.apbx'
out.parent.mkdir(exist_ok=True)
files = sorted(p for p in src.rglob('*') if p.is_file())
with py7zr.SevenZipFile(out, 'w', password='malte', header_encryption=False) as archive:
    for path in files:
        archive.write(path, path.relative_to(src).as_posix())

# Test decoding and verify every extracted byte, including bundled executables.
(ROOT / '.work').mkdir(exist_ok=True)
with tempfile.TemporaryDirectory(prefix='nova-verify-', dir=ROOT / '.work') as temp:
    with py7zr.SevenZipFile(out, 'r', password='malte') as archive:
        assert archive.needs_password()
        assert set(archive.getnames()) == {p.relative_to(src).as_posix() for p in files}
        archive.extractall(temp)
    for path in files:
        assert path.read_bytes() == (Path(temp) / path.relative_to(src)).read_bytes(), path
digest = hashlib.sha256(out.read_bytes()).hexdigest()
out.with_suffix('.apbx.sha256').write_text(f'{digest}  {out.name}\n', encoding='ascii')
print(f'PASS: encrypted archive round trip, {len(files)} files, {out.stat().st_size} bytes')
print(f'SHA256 {digest}')
print(out)
