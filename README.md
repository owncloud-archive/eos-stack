# eos-stack

eos cluster storage images

Disclaimer: Use only for development or testing. Setup is not secured nor tested.

## Releases

- `owncloud/eos-base` is following the [eos](https://eos-docs.web.cern.ch/releases/citrine-release.html) versions.

## Dependencies

- xrootd
- quarksdb

```python
config = {
  'images': [
    'eos-eosd',
    'eos-eosxd',
    'eos-fst',
    'eos-mgm',
    'eos-mq',
    'eos-qdb',
  ],
  'eos_version': '4.6.5',
  'xrd_version': '4.11.0',
  'qdb_version': '0.4.0',
}
```

Eos and its dependencies (xrootd, quarksdb) have some version constraints. Please check compatibility first.

## Releasing

- Choose a working combination of eos_version, xrd_version, qdb_version, edit `.drone.star` and create PR
- Merging that PR will create a `owncloud/eos-*:latest` releases on docker hub.
- Create a tag e.g. `v4.6.5` which is existing as an upstream EOS release and matching with `eos_version`. This will publish `owncloud/eos-*:4.6.5` releases on docker hub.
