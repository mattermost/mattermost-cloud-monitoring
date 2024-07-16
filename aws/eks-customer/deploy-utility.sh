
# # setup git credentials
# function setup_git_credentials() {
#     echo "Setting up git credentials"
#     git config --global user.email "
#     git config --global user.name "
# }

# # get application.yaml file
# function get_application_yaml() {
#     echo "Getting application.yaml file"
#     git clone $git_repo
# }

# # add utility to application.yaml
# function add_utility_to_application_yaml() {
#     echo "Adding utility to application.yaml"
#     echo "utility: true" >> application.yaml
# }

# # create utility custom file
# function create_utility_custom_file() {
#     echo "Creating utility custom file"
#     echo "Creating utility custom file" > utility_custom_file
# }

# # push changes to git
# function push_changes_to_git() {
#     echo "Pushing changes to git"
#     git add .
#     git commit -m "Adding utility to application.yaml"
#     git push
# }

# # wait for the utility to be ready in argocd
# function wait_for_utility_to_be_ready() {
#     echo "Waiting for utility to be ready in argocd"
#     # curl to argocd api to check if the utility is ready
#     sleep 30
# }

# # main function
# function main() {
#     setup_git_credentials
#     get_application_yaml
#     add_utility_to_application_yaml
#     create_utility_custom_file
#     push_changes_to_git
#     wait_for_utility_to_be_ready
# }

echo Utility name: $1 \n Utility version: $2 \n