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
  'qdb_version': '0.4.0',
}

def main(ctx):
    stages = []

    for image in config['images']:
        stages.append(docker(ctx, image, []))
    
    return stages

def docker(ctx, image, depends_on):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'docker-%s' % (image),
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'dryrun',
        'image': 'plugins/docker:18.09',
        'pull': 'always',
        'settings': {
          'dry_run': True,
          'context': '%s' % (image),
          'dockerfile': '%s/Dockerfile' % (image),
          'repo': 'owncloud/%s' % (image),
          'build_args': [
            'EOS_VERSION=%s' % (config['eos_version']),
            'QDB_VERSION=%s' % (config['qdb_version']),
          ],
        },
        'when': {
        'ref': {
            'include': [
              'refs/pull/**',
            ],
          },
        },
      },
      {
        'name': 'docker',
        'image': 'plugins/docker:18.09',
        'pull': 'always',
        'settings': {
          'username': {
          'from_secret': 'public_username',
          },
          'password': {
          'from_secret': 'public_password',
          },
          'auto_tag': True,
          'context': '%s' % (image),
          'dockerfile': '%s/Dockerfile' % (image),
          'repo': 'owncloud/%s' % (image),
          'build_args': [
            'EOS_VERSION=%s' % (ctx.build.ref.replace("refs/tags/v", "") if ctx.build.event == 'tag' else config['eos_version']),
            'QDB_VERSION=%s' % (config['qdb_version']),
          ],
        },
        'when': {
            'ref': {
                'exclude': [
                  'refs/pull/**',
                ],
            },
        },
      },
    ],
    'depends_on': depends_on,
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/v*',
        'refs/pull/**',
      ],
    },
  }