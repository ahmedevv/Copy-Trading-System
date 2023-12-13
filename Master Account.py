import socket
import pandas as pd
import Slave_Account
import Closing
import time
class socketserver:
    def __init__(self, address = '', port = 9090):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.address = address
        self.port = port
        self.sock.bind((self.address, self.port))
        self.cummdata = ''
    def waitforconnection(self):
        
         self.sock.listen(1)
         self.conn, self.addr = self.sock.accept()
         print('Connected to Master Account @:  ', self.addr)
         print('Initiatizing......')
         Slave_Account.initiateObjects()
         return 1


    def recvmsg(self):
        self.cummdata = ''
        while True:
            data = self.conn.recv(10000)
            self.cummdata+=data.decode("utf-8")
            if not data:
                break    

            self.conn.send(bytes(self.cummdata,"utf-8")) # loop back test

            return self.cummdata
   
    def __del__(self):
        
         print('sock close')
         self.sock.close()
        

#####################################################
try: 
   serv = socketserver('127.0.0.1', 9090)
   serv.waitforconnection()
   OldPosition = False

except:
    print('Connection Dropped, Waiting for Connection to Rebuild')
while True: 
         
         msg = serv.recvmsg()
        
         
         
         print('-------Recieved Order Details-------')
         print('received data : ',msg);
         
         if msg != None:
                data = msg.split(',')
                if data[0] == 'New Order':
                    specifier = data[0]
                    position_id = data[1]
                    ticket = data[2]
                    magic = data[3]
                    open_price = data[4]
                    sl = data[5]
                    
                    
                    tp = data[6]
                    
                    
                    tradeTime = data[7]
                    symbol = data[8]
                    volume = data[9]
                    transaction = data[10]
                else:
                    specifier = data[0]
                    ticket = data[1]
                    magic = data[2]
                    open_price = data[3]
                    sl = data[4]             
                    tp = data[5] 
                    tradeTime = data[6]
                    symbol = data[7]
                    volume = data[8]
                    transaction = data[9]
                    position_id = 0
            
                Slave_Account.ExecuteCopyTrading(specifier,int(ticket),int(magic),float(open_price),float(sl),float(tp),tradeTime,symbol,float(volume),transaction,int(position_id))
                print(data)
         

