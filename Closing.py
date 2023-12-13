import MetaTrader5 as mt
import time

import pandas as pd
import datetime
import time
import parameters






    

def getContractSize(Symbol):
    mt.initialize(path=parameters.path,login=parameters.login,password=parameters.password,server=parameters.server)  
    info = mt.symbol_info(Symbol)
    contract_size = info.trade_contract_size
    return contract_size


def getAccountInfo():
    mt.initialize(path=parameters.path,login=parameters.login,password=parameters.password,server=parameters.server)  
    info = mt.account_info()
    balance = info.balance
    return balance

def getSymbolInfo():
    mt.initialize(path=parameters.path,login=parameters.login,password=parameters.password,server=parameters.server) 
    total = mt.symbols_get("*JPY*")
    df=pd.DataFrame(list(total),columns=total[0]._asdict().keys())
    AssetList = df['name'].tolist()
    return AssetList


