## GOLANG- HELLO_WORLD


We have a main.go file where I have wrote a small code for getting a webpage showing hello world. 

We have deployed this application in kubernetes using the helm chart which I have created in this folder.


##################################################################

### Testing it locally

```
docker build -t golang .

docker run -d -p 3333:3000 golang:latest

```
Then the application can be running in http://localhost:3333

![image](https://user-images.githubusercontent.com/46847735/170864923-fe9e24b5-c98c-49d3-940a-1ec0e076b63e.png)


##################################################################

### Testing it cluster and connected with a DNS name or ingress

![image](https://user-images.githubusercontent.com/46847735/170864702-07c07ecd-b72f-47ef-86e7-7b7fee929d6b.png)

The appplication is assigned with a dns name called https://golang-demo.ml/


##################################################################

### checking secure connection

It is also secure connection as it has Let's Encrypt

![image](https://user-images.githubusercontent.com/46847735/170864731-11faf240-98cf-4e13-a9b3-0ab492520f8a.png)


Checking the certificate details.

![image](https://user-images.githubusercontent.com/46847735/170864746-4a7f9475-8bad-4cea-8e98-da8b388a401a.png)
