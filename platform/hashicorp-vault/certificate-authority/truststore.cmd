del truststore.p12
keytool -import -storepass changeit -noprompt -alias ca -file ca.crt -storetype PKCS12 -keystore truststore.p12
keytool -import -storepass changeit -noprompt -alias ca-int -file ca-int.crt -storetype PKCS12 -keystore truststore.p12
move truststore.p12 \\nas.evelyn.internal\terraform\.files\bundles\truststore.p12
