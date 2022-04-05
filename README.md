# Mattermost Terraform Modules

These are the terraform modules which SRE team user to build the Mattermost Cloud infrastructure.

# Contribute

Required Tools:
- Terraform
- [Terraform Docs](https://github.com/terraform-docs/terraform-docs)
- [tflint](https://github.com/terraform-linters/tflint)

```
make lint
```

# Roadmap

- Re-usable modules
- Testing Terraform code (unit, end-to-end)

# Tagging 

We suggest & follow a **semantic version tagging** for this repo. To simplify, a semantic version tag contains three parts. For example, v1.2.3

1. The first number is the major version, which only gets incremented when you make incompatible API or Module changes.(i.e v1 to v2)

2. The second number is the minor version, which gets incremented when you add functionality in a backwards-compatible manner. For example , adding a new module. (i.e v1.2.3 ==> v1.3.0)

3. The third number is the patch version, which gets incremented when you make backwards-compatible bug fixes. For example, if an existing module had a bug that caused an error when the user tried to call it or added a new feature for it etc. (i.e v1.2.3 to v1.2.4)

#### Cheat sheet for git tag 
See the existing tags 
```bash
git tag --online
```
Adding a tag to the last commit 
```bash
git tag -a v1.1.0 HEAD -m "Added new modules"
```

Push the tag to the remote
```bash
git push origin v1.1.0
```

Incase if we need to delete a specific tag

```bash
git tag -d <tag-name>

git push --delete origin <tag-name>
```
