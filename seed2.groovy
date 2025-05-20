pipelineJob('TF Apply') {
  parameters {
    stringParam 'VM_NAME', '', 'VM Name to provision'
  }
  definition {
      cpsScm {
          scm {
              git('https://github.com/msabry2020/jcasc.git','main')
          }
          scriptPath('tf_apply.groovy')
      }
  }
}