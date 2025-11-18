<div align="center">

# asdf-cure [![Build](https://github.com/superruzafa/asdf-cure/actions/workflows/build.yml/badge.svg)](https://github.com/superruzafa/asdf-cure/actions/workflows/build.yml) [![Lint](https://github.com/superruzafa/asdf-cure/actions/workflows/lint.yml/badge.svg)](https://github.com/superruzafa/asdf-cure/actions/workflows/lint.yml)

[cure](https://github.com/am-kantox/cure-lang) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add cure
# or
asdf plugin add cure https://github.com/superruzafa/asdf-cure.git
```

cure:

```shell
# Show all installable versions
asdf list-all cure

# Install specific version
asdf install cure latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cure latest

# Now cure commands are available
cure --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/superruzafa/asdf-cure/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Alfonso Ruzafa](https://github.com/superruzafa/)
