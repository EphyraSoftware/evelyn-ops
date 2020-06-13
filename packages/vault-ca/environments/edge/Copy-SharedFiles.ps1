New-Item -ItemType Directory -Force -Path \\nas.evelyn.internal\terraform\.files\vault-ca
Copy-Item -Force .\ca-bundle.pem \\nas.evelyn.internal\terraform\.files\vault-ca\ca-bundle.pem

Remove-Item truststore.p12
keytool -import -storepass changeit -noprompt -alias ca -file ca.crt -storetype PKCS12 -keystore truststore.p12
keytool -import -storepass changeit -noprompt -alias ca-int -file ca-int.crt -storetype PKCS12 -keystore truststore.p12
Copy-Item .\truststore.p12 \\nas.evelyn.internal\terraform\.files\bundles\truststore.p12
