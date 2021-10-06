Create certificates
===================

Create a CA self signed certificate
-----------------------------------
1. List and select an elliptic curve to use for the key.
```bash
openssl ecparam -list_curves
```

2. Generate the certificate's key.
```bash
openssl ecparam -genkey -name $ellipticCurve -out $path2key 
```

3. Create the self signed certificate.
```bash
openssl req -x509 -new -sha256 -key $path2key -days $durationInDays -out $path2certificate
```

Creating a certificate sign request
-----------------------------------
1. List and select an elliptic curve to use for the key.
```bash
openssl ecparam -list_curves
```
3. Create the certificate's key.
```bash
openssl ecparam -genkey -name $ellipticCurve -out $path2key
```

4. Create the certificate signing request.
```bash
openssl req -new -sha256 -key $path2key -out $path2req
```

> ### NOTE
> Although not necessary, it is common practice to keep certificate sign requests in either a  `.csr` file extension (Certificate Signing Request) or `.req` (Request) format.

> ### NOTE
> Notice that the key and the certificate sign request are, both, independent from the CA's certificate at this moment.

Sign a certificate signing request
----------------------------------
1. Sign the certificate sign request with the CA's certificate.
```bash
openssl x509 -req -sha256 -days $durationInDays -in $path2req -CA $path2caCer -CAkey $path2caKey -CAcreateserial -out $path2reqCer 
```

> ### IMPORTANT
> A `.srl` file will be created in the same directory as the CA certificate.
> This file contains the serial linked to the certificate signing request.

Help
----
[**`openssl ecparam`**](https://www.openssl.org/docs/man1.0.2/man1/ecparam.html)
+ This command is used to manipulate or generate EC parameter files.

[**`openssl req`**](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html)
+ Primarily creates and processes certificate requests in PKCS#10 format. 
+ It can additionally create self signed certificates for use as root CAs for example.

[**`openssl x509`**](https://www.openssl.org/docs/man1.0.2/man1/x509.html)
+ Multi purpose certificate utility. 
+ It can be used to display certificate information, convert certificates to various forms, sign certificate requests like a "mini CA" or edit certificate trust settings.

Relevant links
--------------
+ [Elliptic curves in cryptography](https://en.wikipedia.org/wiki/Elliptic_curve_cryptography).
+ [Internet X.509 Public Key Infrastructure Certificate and Certificate Revocation List (CRL) Profile](https://tools.ietf.org/html/rfc5280)
+ [Certification Request Syntax Specification Version 1.7](https://tools.ietf.org/html/rfc2986)
+ [What is the difference between .pem, .csr, .key and .crt and other such file extensions?](https://crypto.stackexchange.com/questions/43697/what-is-the-difference-between-pem-csr-key-and-crt-and-other-such-file-ext)
