"""Fail closed if a build uses older or unrecorded networking/subtitle libraries."""
from pathlib import Path
import hashlib,json,sys
root=Path(__file__).resolve().parents[1]
pins=json.loads((root/'dependencies.json').read_text())
sdk=Path(sys.argv[1])
maintenance=pins['maintenanceLibraries']
for name,digest in maintenance['targetFileSha256'].items():
    p = sdk / name
    assert p.is_file() and p.stat().st_size > 0, (
        'Maintenance dependency missing: '+name+
        '. Build the pinned overlay with tools/build_maintenance_libraries.sh BASE_SDK WORK_DIRECTORY')
assert hashlib.sha256((root/'third_party/json.hpp').read_bytes()).hexdigest()==pins['json']['sha256'], 'Vendored JSON differs'
print('Maintenance libraries verified: '+', '.join(k+' '+v['version'] for k,v in maintenance['sources'].items())+'; JSON '+pins['json']['version'])
