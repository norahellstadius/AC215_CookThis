echo '{
    "type": "service_account",
    "project_id": "cookthis-400019",
    "private_key_id": "7689219086c817169d2ab54ac339a4796ce35e5b",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDIiVbbJJvEX3Ca\nuZ0pXnmS2KfSeG8r3rAMbmi3NqznZkYpiDznB7qYZkayqadjwZVkfDXFFGGBG1xS\nu6GKZNnMPKOKzhzQkJx2uvpGl4lXFrrgXV7LQMxU+GwmgaGoEnP1ZwAJuI6iOwvi\nfzARP+GSfGdXcp3ZaCXyFv3e/Sx4xRSAwpV8IUE5Ww1o3+5iXAqb6dhOrkX2x938\nCpJkQAEm6waNaqjWiaL2hP7Ddy2NUQZ94g23aFaULxbiNmR4miWD7hTInDi0a43O\nEvNhvMIwK+Ao3kVY6bpUiHAy13SGBgdH6FNKrcVBKTDoMLGo7IYLCqa7FEDkfdMs\n7ZNpNtPLAgMBAAECggEAQ1KEE67PElZeFbuBjP1YABn3ATwISmiInqvEQNm8ozSd\nEl1X4NGh7X7MdjdpaB55mlHutTp531+Bl47BFRZ1XdDvsG4wkz4xINT1p5RA+bk6\nRI9j/wVCc7YwjJ7RV/zV7AlHpHvOep0rCL9dMjVJc6WLBfsHDhEeSA867Ez/TI15\nBaTxFUJ/LJzadJzjRq9/PlJAdE6VKa3CsGl3kKvSeqecxtrc3LkDUil1kWgqLISH\nBxirwnqjcEUcs9IA0kfp+dc+UuhP4fdc64GO+W0lWJSoqIJXFnkhTRJZQ8NrquNx\nEpq+ALDNbv3BDHChv6dgVUxV6iI+9JPs7Vk71sYA2QKBgQDmK+gfVTh6i9sCLE+0\n6o2xgSNtGsDFmFkJ3niFj9+406I6fW+GE5+rYtaP8Dq6aJ1RcensPyLzjXHM/VpC\ns0tRqRU8Rxkco3YeT5xcxAtOY/aNTJBfDiE0ieaK/AkJYYDfm/07eLVIsaLDpFIn\njNbYPHbUb8FBdZneVSTU/2e4swKBgQDfChzZ+KC8N1E+rYX4EcVC8l7gXdUzbnM+\n7ZPpfaJdcDcTsntUAghUYVHCPH0hh4PEpI5KGXcxn201CD3Dq6qMOqnWCxD3leLu\nM3jkdUgMYMtihSRq6qFWLqflOXOFsn8ADUl0zn/sVBmdxwGCDHrcrEkSdAATa1fO\nUHjkfB0UiQKBgQCTX8WOWliBTo76Azk903jKEK+IKjsHyZYpFYMBsa9Dfm4/GRWR\nOXtglzZejyhrNpSUE2X92Cce3o/g+s8SKg6tyJ9KKxPPHHKC0eKCGxxKIwM4Ua+W\nzUtBgpJUpy96DC4h/pTTwWQBmYtnzQy1Oh5N8dj8CFoq+Yt9qfKdVrMotQKBgAN2\nC7aSNiRVk2wukyqjU/VS/4fpzNosd5tdYnM4IOHkUOZ8WY+XLHvqurMR7zsq+C+A\nAjlCJeheOfqdsx+rNU1Rx7rrlwrQh6H8qH6bF1Ah3GYd/M+v7msA9FgJSTKk73WX\nvzER10hakb8yDGLxQKLWBZhEto+Wldk8xHN/PZBJAoGBAIS080Y780j/5Fm/baX3\nM8Ec3JDgYz7XnYGePXJFL9ShRn3o1fZQE/N7u81Wp/y6A27TeLv1KrAg5O3bQvF3\n61pAvfu+RwQzy9JEgh6x2zFHWysOKa+aGhzeOP3pJLLlx9u2N5DHJu2hi1qc6mJz\nV9m65iIb6ZOvLqfJac488nTo\n-----END PRIVATE KEY-----\n",
    "client_email": "data-service-account@cookthis-400019.iam.gserviceaccount.com",
    "client_id": "116794002344909875697",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/data-service-account%40cookthis-400019.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }' > secrets/bucket-reader.json


sudo docker network create momalisa-app

sudo docker run -d --name momalisa-app \
-v "$(pwd)/persistent-folder/":/persistent \
-v "$(pwd)/secrets/":/secrets \
-p 9000:9000 \
-e GOOGLE_APPLICATION_CREDENTIALS=/secrets/bucket-reader.json \
-e GCS_BUCKET_NAME=mushroom-app-models \
--network mushroom-app norahellstadius/momalisa-app-api-service


sudo docker run -d --name frontend -p 3000:80 --network momalisa-app norahellstadius/momalisa-app-frontend


sudo docker run -d --name nginx -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf -p 80:80 --network momalisa-app nginx:stable