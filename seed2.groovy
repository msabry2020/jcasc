pipelineJob('TF_new_Apply') {
  parameters {
    stringParam 'VM_NAME', '', 'VM Name to provision'
  }
  definition {
      cpsScm {
          scm {
              git{
                remote{
                  url('https://github.com/msabry2020/jcasc.git')
                }
                branch('main')
                extensions { }
              }
          }
          scriptPath('tf_apply.groovy')
      }
  }
}