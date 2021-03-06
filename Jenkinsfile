node{
    def NAME_IMGDOCKER = "node-backend-${env.BRANCH_NAME}-ecr"
    def awscredentials = "ecr:us-east-2:aws"
    def ECRREPO = "234596161224.dkr.ecr.us-east-2.amazonaws.com/"

    stage("Pull Git") {
        checkout scm
    }

    stage("Build") {
        sh 'npm i'
    }

    stage("Test") {
        sh 'npm run test'
    }

    stage("Build Docker"){
        sh 'docker build -t '+ NAME_IMGDOCKER +':'+ currentBuild.id +' -f ' +  'Dockerfile .'
        sh 'docker build -t '+ NAME_IMGDOCKER +' -f ' + 'Dockerfile .'
        sh 'docker tag ' + NAME_IMGDOCKER+':' + currentBuild.id + ' ' + ECRREPO + NAME_IMGDOCKER + ':' + currentBuild.id
        sh 'docker tag ' + NAME_IMGDOCKER+':' + currentBuild.id + ' ' + ECRREPO + NAME_IMGDOCKER + ':latest'
    }
    stage("Terraform variables"){
        withCredentials([string(credentialsId: 'aws-access-key', variable: 'access'), string(credentialsId: 'aws-secret-key', variable: 'secret')]) {
          sh "sed -i 's#ACCESS#${access}#g;s#ENV_NAME#${env.BRANCH_NAME}#g;s#BUILD_ID#${currentBuild.id}#g;s#SECRET#${secret}#g' terraform/terraform.tfvars"
          sh "sed -i 's#ENV_NAME#${env.BRANCH_NAME}#g;' terraform/main.tf"
        }

    }
    stage("Terraform"){
        dir("terraform"){
            sh 'terraform init'
            sh 'terraform plan'
            sh 'terraform apply -auto-approve'
        }
    }

    stage("Deploy ECR"){
        sh "aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${ECRREPO.substring(0,ECRREPO.length()-1 )}"
        sh "docker push "+ ECRREPO + NAME_IMGDOCKER + ":" + currentBuild.id
        sh "docker push "+ ECRREPO + NAME_IMGDOCKER + ":latest"
    }



}
