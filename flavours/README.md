## What's in ? 

### Ethereum flavour 

Geth, Parity, Pantheon

### Bitcoin flavour 

Bitcoind

## Dev mode 

Choose your flavour, for example Ethereum Server. 

    cd eth-server 
    vagrant up 


Each time you add a tool or modify existing one, you can provision your modifications by executing

    vagrant provision


To delete the current VM 

     vagrant halt && vagrant destroy 