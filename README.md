# osx-ca-bundler

Tool that bundles together all keychain system certs into one CA bundle to be used together

## Homebrew

You can install the app using our homebrew tap

```sh
brew install SpaceGoGames/formulae/osx-ca-bundler
```

or 

```sh
brew tap SpaceGoGames/formulae
brew install osx-ca-bundler
```

**NOTE: When uninstalling from Homebrew please ensure to first uninstall the Login Items first, brew will not uninstall them.**

## Install from Sources

To install the app from sources we provide a make file to make your life easier

```sh
make install
```

This will install the binary into your local `/usr/local/bin` folder

If you do not want to use the app any longer you can simply uninstall it

```sh
make uninstall
```

## Usage

### Generate a bundle
To generate a cert bundle from your keychain use

```shell
osx-ca-bundler bundle
```

By default, the cert will be written to `~/.bundler/cert.pem`. You can use this path to set your local environment vars in accordance.

```shell
export REQUESTS_CA_BUNDLE=~/.bundler/cert.pem
export NODE_EXTRA_CA_CERTS=~/.bundler/cert.pem
export SSL_CERT_FILE=~/.bundler/cert.pem
```

You can also choose to install or uninstall an login item to set the variables

```sh
osx-ca-bundler env install
osx-ca-bundler env uninstall
```

### Configuration

Check the `~/.bundler/config.json` file which contains some tweaks.

```json
{
  "exportToOpenSLL" : false,
  "interval" : 3600,
  "cert" : "~\/.bundler\/cert.pem"
}
```

### Login Items

To install the bundler into your login items use

```sh
osx-ca-bundler launch install
```

In case you would like to remove it from your login items just uninstall it

```sh
osx-ca-bundler launch uninstall
```

In case you change your configuration or you installed a newer version just refresh the login item

```sh
osx-ca-bundler launch refresh
```
