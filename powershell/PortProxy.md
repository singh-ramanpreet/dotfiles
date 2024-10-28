## add new port proxy

```
netsh interface portproxy add v4tov4 listenport=3000 listenaddress=0.0.0.0 connectport=3000 connectaddress=127.0.0.1
```

## list all

```
netsh interface portproxy show all
```

## delete port proxy

```
netsh interface portproxy delete v4tov4 listenport=3000 listenaddress=0.0.0.0
```

## add new Firewall Inbound rule 

```
New-NetFirewallRule -DisplayName "nextjs 3000" -LocalPort 3000 -Protocol TCP -Direction Inbound -Action Allow
```

## delete Firewall rule

```
Remove-NetFirewallRule -DisplayName "nextjs 3000"
```