# buildrpm

```
inputs: 
  spec:
    description: 'path to the spec file'
    required: true
  version:
    description: 'rpm version that will be defined in rpmbuild'
    required: true
  clean:
    description: 'clean rpmbuild environment before build'
    required: false
    default: false
 
 outputs:
  rpms_path:
    description: 'path to RPMS directory'
```
OS available: *centos7*, *rocky8* and *rocky9*

## Example
```
- name: build RPM package
  id: buildrpm9
  uses: carlospeon/buildrpm@rocky9
  with:
    spec: ${{ env.spec }}
    version: ${{ github.ref_name }}
