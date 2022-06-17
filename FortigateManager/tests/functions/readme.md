# Description

This is where the function tests go.

Make sure to put them in folders reflecting the actual module structure.

It is not necessary to differentiate between internal and public functions here.

The following PSFConfig-Settings are needed for the tests:
```
Set-PSFConfig -Module 'FortigateManager' -Name 'pester.adom' -Value "ThisIsAnID" -Description "The Test ADOM" -AllowDelete -PassThru | Register-PSFConfig
Set-PSFConfig -Module 'FortigateManager' -Name 'pester.packagename' -Value "ThisShoudBeSecret" -Description "The Test Firewall Policy Package" -AllowDelete -PassThru | Register-PSFConfig
Set-PSFConfig -Module 'FortigateManager' -Name 'pester.credentials' -Value $credentials -AllowDelete -PassThru | Register-PSFConfig
Set-PSFConfig -Module 'FortigateManager' -Name 'pester.fqdn' -Value "myFortigateManager.com" -AllowDelete -PassThru | Register-PSFConfig
```

Adding the parameters  `-PassThru | Register-PSFConfig` the settings get saved permanently in the registry.