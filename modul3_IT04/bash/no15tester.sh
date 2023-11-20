echo '
{
  "username": "kelompokit04",
  "password": "passwordit04"
}' > register.json

# testing ab -n 100 -c 10 -p register.json -T application/json http://192.173.4.1:8001/api/auth/register