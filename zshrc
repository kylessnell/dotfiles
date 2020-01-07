[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Prezto

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Kuberenetes/kubectl utils

alias kc='kubectl'
alias kcget='kubectl get pods,deploy,svc,nodes,jobs'
alias kcgetall='kubectl get pods,deploy,svc,nodes,jobs --all-namespaces'
alias kcctx="kubectl config use-context"
function kcbash() { kubectl exec -ti $@ bash; }
function kcipy() { kubectl exec -ti $@ ipython; }

source <(kubectl completion zsh)

# AWS utils

# Get ec2 instances
function listec2() {
    aws ec2 describe-instances \
        --filter Name=instance-state-name,Values=running \
        --output table \
        --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value | [0],Tags[?Key==`Environment`].Value | [0],LaunchTime,PublicIpAddress,PrivateIpAddress] | sort_by(@, &[3])'
}

# Get autoscaling groups
function listag() {
    aws autoscaling describe-auto-scaling-groups \
        --output table \
        --query 'AutoScalingGroups[].[AutoScalingGroupName,LaunchConfigurationName || LaunchTemplate.LaunchTemplateName,Tags[?Key==`Environment`].Value | [0]]'
}

# Get table for SSM params
# Usage: listsecrets <ssm path>
function listsecrets() {
    aws ssm get-parameters-by-path --recursive --path $@ \
        --output table \
        --query 'Parameters[].[Name,Value]'
}

# Create/update SSM param
# Usage: putsecret <ssm path> <value>
function putsecret() {
    aws ssm put-parameter --overwrite --type "String" --name $1 --value $2
}

# Allow to asg replace and then terminate
# Usage: termins <instance id>
function termins() {
    set -e
    local groupname="$(aws autoscaling describe-auto-scaling-instances --instance-ids $@ | jq -r '.AutoScalingInstances[0].AutoScalingGroupName')"
    aws autoscaling detach-instances --no-should-decrement-desired-capacity --auto-scaling-group-name $groupname --instance-ids $@
    aws ec2 terminate-instances --instance-ids $@
    set +e
}

# Test utils

function premetest() {
  django-admin test $1 --verbosity 2 --settings $TESTING_DJANGO_SETTINGS_MODULE --keepdb $2
}

function premetestX() {
  django-admin test $1 --verbosity 2 --settings $TESTING_DJANGO_SETTINGS_MODULE $2
}

