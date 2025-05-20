node {
    stage('Preparation') { // for display purposes
        git branch: 'main',
            url: 'https://github.com/msabry2020/jcasc'
    }
    
    stage('prepare_workspace') { // for display purposes
        sh '''\
            cd dev
            rm -rf .terraform
            rm -f exitcode.txt terraform.plan terraform.plan.txt terraform.plan.ansi terraform.plan.summary terraform.apply.ansi terraform.apply.txt
        '''.stripIndent()
    }
    
    stage('setup_tf') { // for display purposes
        sh '''\
        cd dev
        tf_version='1.11.4'
        tf_arch='linux_amd64'
        tf_zipfile="terraform_${tf_version}_${tf_arch}.zip"
        tf_url="https://releases.hashicorp.com/terraform/${tf_version}/${tf_zipfile}"
        curl -O "${tf_url}"
        if [ ! -x "./bin/terraform" ]
        then
            unzip -o ${tf_zipfile} -d bin
        fi
        '''.stripIndent()
    }

    
    stage('tf_validate') { // for display purposes
        sh '''\
        cd dev
        ./bin/terraform init
        '''.stripIndent()

    }
    
    
    stage('tf_plan') { // for display purposes
        sh '''\
        cd dev
        ./bin/terraform plan \
            -var="vm_name=test_vm" \
            -refresh=true \
            -input=false \
            -out=terraform.plan \
            -detailed-exitcode \
            2>&1 | tee "terraform.plan.ansi"

        echo "exit code: $?"
        echo $? > exitcode.txt
        '''.stripIndent()
    }

    stage('tf_apply') { // for display purposes
        sh '''\
        cd dev
        ./bin/terraform apply \
            -var="vm_name=test_vm" \
            -input=false \
            terraform.plan \
            2>&1 | tee "terraform.apply.ansi"
        '''.stripIndent()
    }    
}