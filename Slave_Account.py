import pandas as pd
import MetaTrader5 as mt5
import Closing


class Slave:
    def __init__(self, login,password,servername,path,objectID,mt5):
        self.login = login
        self.password = password
        self.servername = servername
        self.path = path
        self.objectID = objectID
        self.MasterTicket = 0
        self.MasterTicketList = []
        self.OrderDict = {}
        
        

    def initializeMetatrader(self):
        try:
            print('Initializing Metatraders')
            if not mt5.initialize(self.path,login=self.login,password=self.password,server=self.servername):
                print("initialize() failed, error code =",mt5.last_error())
                LoginFlag = False
                return(LoginFlag)
                #quit()
            #self.mt5.initialize(self.path,login=self.login,password=self.password,server=self.servername)
        except:
            print('Check Metatrader Credentials i.e. Login,Password,Server')
    def OpenPosition(self,ticket,magic,open_price,sl,tp,time,symbol,volume,transaction):
        try:
            request = {}
            self.MasterTicket = ticket
            print(self.MasterTicket)
            print('Opening Market Trade on Account # ', self.login)
            if transaction == 'ORDER_TYPE_BUY':
                request = {
                            "action": mt5.TRADE_ACTION_DEAL,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_BUY,
                            "price": mt5.symbol_info_tick(symbol).ask,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            elif transaction == 'ORDER_TYPE_SELL':

                request = {
                            "action": mt5.TRADE_ACTION_DEAL,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_SELL,
                            "price": mt5.symbol_info_tick(symbol).bid,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            
            mt5.order_send(request)
        except Exception as e:
            print(e)
    def ClosingPosition(self,ticket,symbol,volume,transaction):
        try:
            request = {}
            print('Volume for Closing Trade is :', volume)
            if transaction == 'ORDER_TYPE_SELL' or transaction == 'ORDER_TYPE_BUY':
                print('Closing Trade on Account # ', self.login)
                request = {
                "action": mt5.TRADE_ACTION_DEAL,
                "position": ticket,
                "symbol": symbol,
                "volume": float(volume),
                "type": mt5.ORDER_TYPE_BUY if transaction == 'ORDER_TYPE_SELL' else mt5.ORDER_TYPE_SELL,
                "price": mt5.symbol_info_tick(symbol).ask if transaction == 'ORDER_TYPE_SELL' else mt5.symbol_info_tick(symbol).bid,  
                "deviation": 20,
                "magic": 100,
                "comment": "python script close",
                "type_time": mt5.ORDER_TIME_GTC,
                "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            elif (transaction == 'ORDER_TYPE_BUY_LIMIT' or transaction == 'ORDER_TYPE_SELL_LIMIT' or transaction == 'ORDER_TYPE_BUY_STOP' or transaction == 'ORDER_TYPE_SELL_STOP' or transaction == 'ORDER_TYPE_BUY_STOP_LIMIT' or transaction == 'ORDER_TYPE_SELL_STOP_LIMIT'):
                print('Closing Trade on Account # ', self.login)
                request  = {
            
                "action": mt5.TRADE_ACTION_REMOVE,
                "order": ticket,
                "type_time": mt5.ORDER_TIME_GTC,
                "type_filling": mt5.ORDER_FILLING_IOC,
                
                    }
                
            details = mt5.order_send(request)
            print(details)
        except Exception as e:
            print(e)
            
        

        # Pending Position Function
    def PendingPosition(self,ticket,magic,open_price,sl,tp,time,symbol,volume,transaction):
        try:
            request = {}
            self.MasterTicket = ticket
            print('Opening Pending Trade on Account # ', self.login)
            if transaction == 'ORDER_TYPE_BUY_LIMIT':
                request = {
                                "action": mt5.TRADE_ACTION_PENDING,
                                "symbol": symbol,
                                "volume": float(volume),
                                "type": mt5.ORDER_TYPE_BUY_LIMIT,
                                "price": open_price,
                                'tp' : float(tp),
                                'sl' : float(sl),
                                "magic": magic,
                                "comment": "Copy Trading",
                                "type_time": mt5.ORDER_TIME_GTC,
                                "type_filling": mt5.ORDER_FILLING_IOC,
                        }
            elif transaction == 'ORDER_TYPE_SELL_LIMIT':
                request = {
                            "action": mt5.TRADE_ACTION_PENDING,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_SELL_LIMIT,
                            "price": open_price,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            elif transaction == 'ORDER_TYPE_BUY_STOP':
                request = {
                            "action": mt5.TRADE_ACTION_PENDING,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_BUY_STOP,
                            "price": open_price,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            elif transaction == 'ORDER_TYPE_SELL_STOP':
                request = {
                            "action": mt5.TRADE_ACTION_PENDING,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_SELL_STOP,
                            "price": open_price,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    }
            elif transaction == 'ORDER_TYPE_BUY_STOP_LIMIT':
                request = {
                            "action": mt5.TRADE_ACTION_PENDING,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_BUY_STOP_LIMIT,
                            "price": open_price,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    } 
            elif transaction == 'ORDER_TYPE_SELL_STOP_LIMIT':
                request = {
                            "action": mt5.TRADE_ACTION_PENDING,
                            "symbol": symbol,
                            "volume": float(volume),
                            "type": mt5.ORDER_TYPE_SELL_STOP_LIMIT,
                            "price": open_price,
                            'tp' : float(tp),
                            'sl' : float(sl),
                            "magic": magic,
                            "comment": "Copy Trading",
                            "type_time": mt5.ORDER_TIME_GTC,
                            "type_filling": mt5.ORDER_FILLING_IOC,
                    } 
            
            mt5.order_send(request)
        except Exception as e:
            print(e)



    def PositionModification(self,ticket,price,sl,tp,transaction):
        print('Modifying Trade on Account # ', self.login)
        request = {}
        try:
            if transaction == 'ORDER_TYPE_SELL' or transaction == 'ORDER_TYPE_BUY':
                request = {
                                'action': mt5.TRADE_ACTION_SLTP,
                                'position': ticket,
                                'sl': sl,
                                'tp' : tp
                            }
                
                
            elif (transaction == 'ORDER_TYPE_BUY_LIMIT' or transaction == 'ORDER_TYPE_SELL_LIMIT' or transaction == 'ORDER_TYPE_BUY_STOP' or transaction == 'ORDER_TYPE_SELL_STOP' or transaction == 'ORDER_TYPE_BUY_STOP_LIMIT' or transaction == 'ORDER_TYPE_SELL_STOP_LIMIT'):
                print('Modifying Trade on Account # ', self.login)
                request  = {
                        'action': mt5.TRADE_ACTION_MODIFY,
                        'order': ticket,
                        "price": price,
                        'sl': sl,
                        'tp' : tp
                    }
                
            mt5.order_send(request)
        except Exception as e:
            print(e)


    # Lot Size Calculator

    def lotSizeCalculator(self,open_price,sl,symbol,volume):
        
        MasterContract = Closing.getContractSize(symbol)
        MasterRisk_USD = 0
        # Getting Jpy Pairs Asset Lists
        AssetList = Closing.getSymbolInfo()
        # Calculate How much risk is on Master Account (USD)
        if symbol in AssetList:
            MasterRisk_USD = abs(open_price-sl) * (MasterContract*volume)
            MasterRisk_USD = MasterRisk_USD/100
        else:
            MasterRisk_USD = abs(open_price-sl) * (MasterContract*volume)
        print('Risk in USD for Master Account in Current Trade is: ', MasterRisk_USD)
        # Get Account Balance
        MasterBalance = Closing.getAccountInfo()
        # Calculating How much Risk in terms of Percentage is on Master Acount Trade
        MasterRisk_PCT = (MasterRisk_USD*100)/ MasterBalance
        print('Risk for Master Account is: ', MasterRisk_PCT)
        # Calculating RR for Slave Accounts 
        # Calculating USD for Trade
        self.initializeMetatrader()
        SlaveInfo = mt5.account_info()
        
        SlaveBalance = SlaveInfo.balance
        print('Balance for {} is {}'.format(self.login,SlaveBalance))
        # Risking on Slave Account According to Conditions met on Masters Account 
        SlaveRisk_USD = (SlaveBalance*MasterRisk_PCT) / 100
        if symbol in AssetList:
            sl = abs(open_price-sl)/100
            lotSize = SlaveRisk_USD / (sl*MasterContract)
            lots = float("{:.1f}".format(lotSize))
        else:
            sl = abs(open_price-sl)
            lotSize = SlaveRisk_USD / (sl*MasterContract)
            lots = float("{:.1f}".format(lotSize))
        return lots

         






    def fetchPositions(self):
        positons = mt5.positions_get()
        self.OrderDict[self.MasterTicket] = positons[-1].ticket
        
    def fetchOrders(self):
        orders = mt5.orders_get()
        self.OrderDict[self.MasterTicket] = orders[-1].ticket
    def fetchVolume(self,ticket):
        positons = mt5.positions_get(ticket=ticket)
        volume = positons[0].volume
        return float(volume)
            
    








df = pd.read_csv('Account.csv')
object_list = []
def initiateObjects():
    for i in range(0,len(df)):
        try: 
            login = df['Login'].iloc[i]
            login = int(login)
            password = df['Password'].iloc[i]
            Server = df['Server'].iloc[i]
            pathname = df['Path'].iloc[i]
            path = 'C:/Program Files/'+pathname+'/terminal64.exe'
            MtInstance = Slave(login,password,Server,path,i,mt5)
            LoginFlag = MtInstance.initializeMetatrader()
            if LoginFlag == False:
                continue
            object_list.append(MtInstance)
        except Exception as e:
            print(e)
    
def ExecuteCopyTrading(specifier,ticket,magic,open_price,sl,tp,time,symbol,volume,transaction,id):

    for i in range(0,len(object_list)):
        
        
        
        LoginFlag = object_list[i].initializeMetatrader()
        if LoginFlag == False:
                continue
        # First Possibility
        if id == 0:

        
            if ticket not in object_list[i].MasterTicketList and (transaction == 'ORDER_TYPE_SELL' or transaction == 'ORDER_TYPE_BUY') and specifier == 'New Order':
                object_list[i].MasterTicketList.append(ticket)
                
                lot = object_list[i].lotSizeCalculator(open_price,sl,symbol,volume)
                print('Volume for the Trade: ', volume)
                object_list[i].OpenPosition(ticket,magic,open_price,sl,tp,time,symbol,lot,transaction)
                object_list[i].fetchPositions()

            elif specifier == 'New Order' and (transaction == 'ORDER_TYPE_BUY_LIMIT' or transaction == 'ORDER_TYPE_SELL_LIMIT' or transaction == 'ORDER_TYPE_BUY_STOP' or transaction == 'ORDER_TYPE_SELL_STOP' or transaction == 'ORDER_TYPE_BUY_STOP_LIMIT' or transaction == 'ORDER_TYPE_SELL_STOP_LIMIT'):
                object_list[i].MasterTicketList.append(ticket)
                # object_list[i].initializeMetatrader()
                lot = object_list[i].lotSizeCalculator(open_price,sl,symbol,volume)
                print('Volume for the Trade: ', volume)
                object_list[i].PendingPosition(ticket,magic,open_price,sl,tp,time,symbol,lot,transaction)
                object_list[i].fetchOrders()

            # Possibility for Closing of Position and Modification of Position
            elif (specifier == 'Deletion Order' or specifier == 'Delete Order') and ticket in object_list[i].MasterTicketList:
                    # Closing of the Position
                    SlaveTicket = object_list[i].OrderDict.get(ticket)
                    print('Slave Ticket is :', SlaveTicket)
                    #object_list[i].initializeMetatrader()
                    if transaction == 'ORDER_TYPE_BUY' or transaction == 'ORDER_TYPE_SELL':
                        tradeSize = object_list[i].fetchVolume(SlaveTicket)
                        object_list[i].ClosingPosition(SlaveTicket,symbol,tradeSize,transaction)
                    else:
                        print('Volume for the Closing Trade: ', volume)
                        object_list[i].ClosingPosition(SlaveTicket,symbol,volume,transaction)


        # Pending Order

            elif (specifier == 'Modifying Orders' or specifier == 'Modified Order' ) and ticket in object_list[i].MasterTicketList:
                    SlaveTicket = object_list[i].OrderDict.get(ticket)
                    #object_list[i].initializeMetatrader()
                    object_list[i].PositionModification(SlaveTicket,open_price,sl,tp,transaction)
        #Second Possibility   
        if id != 0 and id != ticket:
            if (specifier == 'New Order') and id in object_list[i].MasterTicketList:
                    # Closing of the Position
                    SlaveTicket = object_list[i].OrderDict.get(id)
                    print('Slave Ticket is :', SlaveTicket)
                    #object_list[i].initializeMetatrader()
                    if transaction == 'ORDER_TYPE_BUY' or transaction == 'ORDER_TYPE_SELL':
                        tradeSize = object_list[i].fetchVolume(SlaveTicket)
                        object_list[i].ClosingPosition(SlaveTicket,symbol,tradeSize,transaction)
                    else:
                        print('Volume for the Closing Trade: ', volume)
                        object_list[i].ClosingPosition(SlaveTicket,symbol,volume,transaction)

        # Third Possibility
        if id == ticket:
            if ticket not in object_list[i].MasterTicketList and (transaction == 'ORDER_TYPE_SELL' or transaction == 'ORDER_TYPE_BUY') and specifier == 'New Order':
                object_list[i].MasterTicketList.append(ticket)
                
                lot = object_list[i].lotSizeCalculator(open_price,sl,symbol,volume)
                print('Volume for the Trade: ', volume)
                object_list[i].OpenPosition(ticket,magic,open_price,sl,tp,time,symbol,lot,transaction)
                
                object_list[i].fetchPositions()

            elif specifier == 'New Order' and (transaction == 'ORDER_TYPE_BUY_LIMIT' or transaction == 'ORDER_TYPE_SELL_LIMIT' or transaction == 'ORDER_TYPE_BUY_STOP' or transaction == 'ORDER_TYPE_SELL_STOP' or transaction == 'ORDER_TYPE_BUY_STOP_LIMIT' or transaction == 'ORDER_TYPE_SELL_STOP_LIMIT'):
                object_list[i].MasterTicketList.append(ticket)
                # object_list[i].initializeMetatrader()
                lot = object_list[i].lotSizeCalculator(open_price,sl,symbol,volume)
                print('Volume for the Trade: ', lot)
                object_list[i].PendingPosition(ticket,magic,open_price,sl,tp,time,symbol,lot,transaction)
                object_list[i].fetchOrders()
