config = {
  'images': [
    'eos-eosd',
    'eos-eosxd',
    'eos-fst',
    'eos-mgm',
    'eos-mq',
    'eos-qdb',
  ],
}

def main(ctx):
    stages = []
    stages.append(docker(ctx, 'eos-base', []))

    for image in config['images']:
        stages.append(docker(ctx, image, ['docker-eos-base']))
    
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
        'repo': ctx.repo.slug,
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
            'from_secret': 'docker_username',
            },
            'password': {
            'from_secret': 'docker_password',
            },
            'auto_tag': True,
            'context': '%s' % (image),
            'dockerfile': '%s/Dockerfile' % (image),
            'repo': ctx.repo.slug,
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