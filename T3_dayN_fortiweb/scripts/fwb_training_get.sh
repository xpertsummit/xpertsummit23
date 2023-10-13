#!/bin/bash
# Curl commands to create API Protection Model

# Variables
DNS_NAME="xpertsummit-es.com"

# Get user ARN
caller_identity=$(aws sts get-caller-identity)
# Extract lab Owner from AWS caller identity
lab_owner=$(echo "$caller_identity" | jq -r '.Arn' | awk -F '[:/]' '{print $NF}')

URL="http://$lab_owner.$DNS_NAME"

echo "------------------------------------------------------------------------"
echo "Sending API GET requests to ${URL}/"
echo "------------------------------------------------------------------------"

for ((i=1; i<100; i++))
do
  echo -n "GET : ${URL} - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl  -k -H "X-Forwarded-For: ${IPADDRESS}" -A ML-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/v2/pet/findByStatus?status=available" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""

  echo -n "GET : ${URL} - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl -k -H "X-Forwarded-For: ${IPADDRESS}" -A ML-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/v2/pet/findByStatus?status=pending" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""

  echo -n "GET : ${URL} - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl -k -H "X-Forwarded-For: ${IPADDRESS}" -A ML-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/v2/pet/findByStatus?status=sold" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""
done

echo "-------------------------------------------------------------------------------------------"
echo "FortiWeb ML-API trained with GET method on ${URL}/"
echo "-------------------------------------------------------------------------------------------"
