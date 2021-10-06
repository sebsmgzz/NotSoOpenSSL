NotSoOpenSSL
============
This is wrapper around the commonly know openSSL software. Although openSSL is **NOT** included within project, it is required for the scripts to run.

Requirements
------------
+ Install openssl from [here](https://www.openssl.org/)
+ Check their source code [here](https://github.com/openssl/openssl)

How to use
----------

1. Create a key and and a self sign certificate.
```powershell
Create-Key "root"
Create-Certificate "root"
```

2. Create a certificate sign request.
```powershell
Create-Key "leaf"
Create-Certificate "leaf" -SignRequest
```

3. Sign your certificate for 365 days.
```powershell
Sign-Certificate "root" "leaf" 365
```
