pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "ap-south-1"
    }

    stages {
        stage('Checkout Code') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                git 'https://github.com/your-repo/terraform-ansible-project.git'
            }
        }

        stage('Terraform Init') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Approve Terraform Plan?", parameters: [text(name: 'Plan', description: 'Review the plan:', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Fetch EC2 Public IP & Create Ansible Inventory') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                script {
                    dir('terraform') {
                        def ec2_ip = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                        writeFile file: "ansible/inventory.ini", text: "[web]\n${ec2_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            when {
                not { equals expected: true, actual: params.destroy }
            }
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }

        stage('Destroy Resources') {
            when {
                equals expected: true, actual: params.destroy
            }
            steps {
                dir('terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
