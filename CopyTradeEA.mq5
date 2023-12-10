//+------------------------------------------------------------------+
//|                                                  CopyTradeEA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#define totalObject 1000
int My_Socket_Handle = INVALID_HANDLE; 
struct  orderDetails
  {

   ulong               orderTicket;
   string              symbol;
   double              volume;
   string              type;
   double              price;
   double              takeProfit;
   double              stopLoss;
   long                magicNo;
   datetime            orderTime;
   long                posid;
                     orderDetails()
     {
      orderTicket = -1;
      symbol      = "";
      volume      = -1;
      type        = "";
      price       = -1;
      takeProfit  = -1;
      stopLoss    = -1;
      magicNo     = -1;
      orderTime   = -1;
      posid       = -1;
     }

  };

orderDetails od[totalObject];


struct  modifiedOrderDetails
  {

   ulong               orderTicket;
   string              symbol;
   double              volume;
   string              type;
   double              price;
   double              takeProfit;
   double              stopLoss;
   long                magicNo;
   datetime            orderTime;
   long                mpid;
                     modifiedOrderDetails()
     {
      orderTicket = -1;
      symbol      = "";
      volume      = -1;
      type        = "";
      price       = -1;
      takeProfit  = -1;
      stopLoss    = -1;
      magicNo     = -1;
      orderTime   = -1;
      mpid        = -1;
     }

  };

modifiedOrderDetails Mod[totalObject];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  OnTimer()
  {

  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
My_Socket_Handle = Socket_Connect(); 
   for(int j=0; j<totalObject; j++)
     {
      od[j].orderTicket = -1;

     }
//OnTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
Socket_Close(My_Socket_Handle);
  }
int orderCountpend = 0;
int orderCountLive = 0;
bool modify = true;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

bool active = true;
bool pending = true;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {



   if(active)
     {
      if(orderCountLive ==  countlive())
        {
         ModifiedOrderlive();
         ModifiedLotOrder();
        }



      if(orderCountLive <  countlive())
        {
         orderCountLive = countlive();
         int waitTime = 2000; // 2 seconds in milliseconds
         Sleep(waitTime);
         CheckIfOpenOrderlive();
         //CheckOrderOpenLive();
        }




      if(orderCountLive > countlive())
        {
         CheckOrderOpenLive();
         orderCountLive = countlive();
        }


     }

   int waitTime = 2000; // 2 seconds in milliseconds
   Sleep(waitTime);

   if(pending)
     {


        {


         if(orderCountpend ==  countpending())
           {
            ModifiedOrderpending();
           }

         if(orderCountpend < countpending())
           {

            orderCountpend = countpending();
            CheckIfOpenOrderpending();
            //   CheckOrderOpenPending();


           }
         if(orderCountpend > countpending())
           {
            CheckOrderOpenPending();
            orderCountpend = countpending();
           }



        }


     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int countpending()
  {
   int cnt = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      cnt++;
     }

   return cnt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int countlive()
  {
   int cnt = 0;

   for(int i=0; i < PositionsTotal(); i++)
     {
      cnt++;
     }

   return cnt;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifiedLotOrder()
  {

   for(int i=0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      double checkSL= -1,checkTp= -1, openPrice,volume1;

      if(searchFromStructure1(ticket,checkSL,checkTp,openPrice,volume1) == false)
        {

         double tp          = PositionGetDouble(POSITION_TP);
         double Sl          = PositionGetDouble(POSITION_SL);
         double volume      = PositionGetDouble(POSITION_VOLUME);


         if(Sl != checkSL ||  checkTp != tp || volume != volume1)
           {
            double vol = volume1 - volume;
            double open_price  = PositionGetDouble(POSITION_PRICE_OPEN);
            string symbol      = PositionGetString(POSITION_SYMBOL);
            long order_magic   = PositionGetInteger(POSITION_MAGIC);
            double volume      = PositionGetDouble(POSITION_VOLUME);
            string type        = EnumToString(ENUM_ORDER_TYPE(PositionGetInteger(POSITION_TYPE)));
            tp                 = PositionGetDouble(POSITION_TP);
            Sl                 = PositionGetDouble(POSITION_SL);
            datetime time      = (datetime)PositionGetInteger(POSITION_TIME);
            long positionID    = PositionGetInteger(POSITION_IDENTIFIER);


            if(alreadyExistsMOdified(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,positionID) == false)
              {
               //  Print("0",volume,"1",volume1);
               //  Print("volume ",volume," new volume is ",vol);

               modifiedAddToStructure(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,"Delete Order,",vol,positionID);
               updatevolumeinbasetrade(ticket,volume);
               volume1 = volume;
              }

           }
         else
           {
            // Print("position Tp is same : ",ticket);
           }
        }


     }





  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifiedOrderlive()
  {



   for(int i=0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      double checkSL= -1,checkTp= -1, openPrice;

      if(searchFromStructure(ticket,checkSL,checkTp,openPrice) == false)
        {
         double tp          = PositionGetDouble(POSITION_TP);
         double Sl          = PositionGetDouble(POSITION_SL);


         if(Sl != checkSL ||  checkTp != tp)
           {

            double open_price  = PositionGetDouble(POSITION_PRICE_OPEN);
            string symbol      = PositionGetString(POSITION_SYMBOL);
            long order_magic   = PositionGetInteger(POSITION_MAGIC);
            double volume      = PositionGetDouble(POSITION_VOLUME);
            string type        = EnumToString(ENUM_ORDER_TYPE(PositionGetInteger(POSITION_TYPE)));
            tp                 = PositionGetDouble(POSITION_TP);
            Sl                 = PositionGetDouble(POSITION_SL);
            datetime time      = (datetime)PositionGetInteger(POSITION_TIME);
            long positionID    = PositionGetInteger(POSITION_IDENTIFIER);


            if(alreadyExistsMOdified(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,positionID) == false)
              {

               modifiedAddToStructure(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,"Modified Order,",1,positionID);
              }

           }
         else
           {
            // Print("position Tp is same : ",ticket);
           }
        }


     }



  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifiedOrderpending()
  {
   int Orders   =  OrdersTotal();

   if(Orders > 0)
     {
      for(int i=0; i<Orders; i++)
        {
         ulong ticket = OrderGetTicket(i);
         double checkSL= -1,checkTp= -1, openPrice;

         if(searchFromStructure(ticket,checkSL,checkTp,openPrice) == false)
           {

            if(OrderSelect(ticket))
              {
               double tp          = OrderGetDouble(ORDER_TP);
               double Sl          = OrderGetDouble(ORDER_SL);
               double open_price  = OrderGetDouble(ORDER_PRICE_OPEN);

               if(Sl != checkSL ||  checkTp != tp || open_price != openPrice)
                 {
                  open_price         = OrderGetDouble(ORDER_PRICE_OPEN);
                  string symbol      = OrderGetString(ORDER_SYMBOL);
                  long order_magic   = OrderGetInteger(ORDER_MAGIC);
                  long positionID    = OrderGetInteger(ORDER_POSITION_ID);
                  double volume      = OrderGetDouble(ORDER_VOLUME_INITIAL);
                  string type        = EnumToString(ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE)));
                  tp                 = OrderGetDouble(ORDER_TP);
                  Sl                 = OrderGetDouble(ORDER_SL);
                  datetime time      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
                  // Print("modifiing");

                  if(alreadyExistsMOdified(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,positionID) == false)
                    {

                     modifiedAddToStructure(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,"Modified Order,",1,positionID);
                    }
                 }
               else
                 {
                  //  Print("Tp is same : ");
                 }

              }

           }


        }


     }





  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckIfOpenOrderpending()
  {
   int Orders   =  OrdersTotal();

   if(Orders > 0)
     {
      for(int i=0; i<Orders; i++)
        {
         ulong ticket = OrderGetTicket(i);

         if(OrderSelect(ticket))
           {
            //Print(ticket);
            double open_price  = OrderGetDouble(ORDER_PRICE_OPEN);
            string symbol      = OrderGetString(ORDER_SYMBOL);
            long order_magic   = OrderGetInteger(ORDER_MAGIC);
            long positionID    = OrderGetInteger(ORDER_POSITION_ID);
            double volume      = OrderGetDouble(ORDER_VOLUME_INITIAL);
            string type        = EnumToString(ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE)));
            double tp          = OrderGetDouble(ORDER_TP);
            double Sl          = OrderGetDouble(ORDER_SL);
            datetime time      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);

            if(alreadyExists1(ticket) == false)
              {
               // Print("in active add value ",i);
               addToStructure(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,positionID);
               // Print(" in order total is ",positionID);
              }



           }

        }


     }




  }



//+------------------------------------------------------------------+
void CheckIfOpenOrderlive()
  {

   for(int i=0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      double checkSL= -1,checkTp= -1;

      double price1;
      if(searchFromStructure(ticket,checkSL,checkTp,price1))
        {
         if(PositionSelectByTicket(ticket))
           {

            double open_price  = PositionGetDouble(POSITION_PRICE_OPEN);
            string symbol      = PositionGetString(POSITION_SYMBOL);
            long order_magic   = PositionGetInteger(POSITION_MAGIC);
            double volume      = PositionGetDouble(POSITION_VOLUME);
            string type        = EnumToString(ENUM_ORDER_TYPE(PositionGetInteger(POSITION_TYPE)));
            double tp          = PositionGetDouble(POSITION_TP);
            double Sl          = PositionGetDouble(POSITION_SL);
            datetime time      = (datetime)PositionGetInteger(POSITION_TIME);
            long positionID    = PositionGetInteger(POSITION_IDENTIFIER);


            if(alreadyExists(ticket,positionID) == false)
              {
               //   Print(" in position add value ",i);
               addToStructure(ticket,open_price,symbol,order_magic,volume,type,time,Sl,tp,positionID);
               //  Print("in position loop",positionID);
              }

           }
        }
     }



  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool searchFromStructure1(ulong ticket,double & Sl,double & Tp,double & openPrice,double & volume)
  {
//  Print("here");
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {
         //   Print("ticket found");
         Sl = od[j].stopLoss;
         Tp = od[j].takeProfit;
         openPrice = od[j].price;
         volume = od[j].volume;

         od[j].stopLoss = Sl;
         od[j].takeProfit = Tp;
         od[j].price = openPrice;
         od[j].volume = volume;

         return false;
        }
     }
   return true;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void updatevolumeinbasetrade(ulong ticket,double & volume)
  {

   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {

         od[j].volume = volume;


        }
     }
  }
//+------------------------------------------------------------------+
bool searchFromStructure(ulong ticket,double & Sl,double & Tp,double & openPrice)
  {
//  Print("here");
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {
         //   Print("ticket found");
         Sl = od[j].stopLoss;
         Tp = od[j].takeProfit;
         openPrice = od[j].price;

         od[j].stopLoss = Sl;
         od[j].takeProfit = Tp;
         od[j].price = openPrice;


         return false;
        }
     }
   return true;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool alreadyExistsMOdified(ulong ticket,double openPrice,string symbol,long magicNo,double volume,string type,datetime time, double sl, double tp,double id)
  {
   for(int j=0; j<totalObject; j++)
     {
      if(Mod[j].orderTicket == ticket && Mod[j].price == openPrice && Mod[j].stopLoss == sl && Mod[j].takeProfit == tp && Mod[j].volume == volume && Mod[j].mpid == id)
        {
         // Print("ticket already exists");
         return true;

        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool alreadyExists1(ulong ticket)
  {
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {
         return true;

        }

     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool alreadyExists(ulong ticket,double id)
  {
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {

         // Print("ticket already exists");
         return true;

        }
      if(od[j].posid == id)
        {

         return true;
        }
      if(od[j].orderTicket == id)
        {
         return true;
        }
     }

   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifiedAddToStructure(ulong ticket,double openPrice,string symbol,long magicNo,double volume,string type,datetime time, double sl, double tp,string str,double vol,long id)
  {
   for(int j=0; j<totalObject; j++)
     {
      // Print("in modified structure");
      if(Mod[j].orderTicket == -1)
        {

         Mod[j].orderTicket = ticket;
         Mod[j].magicNo     = magicNo;
         Mod[j].price       = openPrice;
         Mod[j].stopLoss    = sl;
         Mod[j].takeProfit  = tp;
         Mod[j].orderTime   = time;
         Mod[j].symbol      = symbol;
         Mod[j].volume      = volume;
         Mod[j].type        = type;
         Mod[j].mpid        = id;

         // Print("ticket : ",ticket," magicNo : ",magicNo," openPrice : ",openPrice," sl : ",sl,
         //     " tp : ",tp," time : ",time," symbol : ",symbol," volume : ",volume," type : ",type);
         if(str == "Modified Order,")
           {
            string data =str+(string)ticket+","+(string)magicNo+","+(string)openPrice+","+(string)sl+","+(string)tp+","+(string)time+","+(string)symbol+","+(string)volume+","+(string)type;
            Print(data);
            Socket_Send(My_Socket_Handle,data);
           }
         else
           {
            //  Mod[j].volume   = vol;
            //  Print(vol);
            //  Print(volume);
            string data =str+(string)ticket+","+(string)magicNo+","+(string)openPrice+","+(string)sl+","+(string)tp+","+(string)time+","+(string)symbol+","+(string)vol+","+(string)type;
            Print(data);
            Socket_Send(My_Socket_Handle,data);
           }


         break;
        }
     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addToStructure(ulong ticket,double openPrice,string symbol,long magicNo,double volume,string type,datetime time, double sl, double tp,long id)
  {
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == -1)
        {

         od[j].orderTicket = ticket;
         od[j].magicNo     = magicNo;
         od[j].price       = openPrice;
         od[j].stopLoss    = sl;
         od[j].takeProfit  = tp;
         od[j].orderTime   = time;
         od[j].symbol      = symbol;
         od[j].volume      = volume;
         od[j].type        = type;
         od[j].posid       = id;

         string data ="New Order,"+(string)id+","+(string)ticket+","+(string)magicNo+","+(string)openPrice+","+(string)sl+","+(string)tp+","+(string)time+","+(string)symbol+","+(string)volume+","+(string)type;
         Print(data);
         Socket_Send(My_Socket_Handle,data);


         //    Print("ticket : ",ticket," magicNo : ",magicNo," openPrice : ",openPrice," sl : ",sl,
         //        " tp : ",tp," time : ",time," symbol : ",symbol," volume : ",volume," type : ",type);
         break;
        }
     }


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void tradeStructureValues()
  {
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket != -1)
        {
         //   Print("simple Trades :: ticket : ",od[j].orderTicket," Symbol ",od[j].symbol," type : ",od[j].type);

        }
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void tradeStructureValuesModified()
  {
   for(int j=0; j<totalObject; j++)
     {
      if(Mod[j].orderTicket != -1)
        {
         //Print("MOdified Trade ticket : ",Mod[j].orderTicket," Symbol ",Mod[j].symbol," type : ",Mod[j].type);

        }
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifiedStructureValues()
  {
   for(int j=0; j<totalObject; j++)
     {
      if(Mod[j].orderTicket != -1)
        {
         //   Print("ticket : ",Mod[j].orderTicket," Symbol ",Mod[j].symbol," type : ",Mod[j].type," Tp is ",Mod[j].takeProfit,
         //      " sl is ",Mod[j].stopLoss," open price is ",Mod[j].price);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckOrderOpenLive()
  {

   ulong ticket;
   ulong Positionticket;
   for(int j=0; j<totalObject; j++)
     {

      if(od[j].orderTicket != -1)
        {
         bool found1 = false;
         bool found2 = false;
         ticket = od[j].orderTicket;
         long id  = od[j].posid;
         //  Print("in function ",ticket);

         for(int i=0; i < PositionsTotal(); i++)
           {
            Positionticket = PositionGetTicket(i);
            long pid = PositionGetInteger(POSITION_IDENTIFIER);
            if(Positionticket == ticket)
              {
               found1 = true;
              }
            //if(pid == id)
            //  {
            //   found1 = true;
            //  }
           }

         for(int i=0; i <  OrdersTotal(); i++)
           {
            ulong orderticket = OrderGetTicket(i);
            if(orderticket == ticket)
              {
               found2 = true;
              }
           }

         // Print(found1,found2);
         if(found1 == false && found2 == false)
           {
            //    Print("ticket is closed :");

            ulong  ticket = od[j].orderTicket;
            long magicNo = od[j].magicNo;
            double openPrice = od[j].price;
            double sl = od[j].stopLoss;
            double tp = od[j].takeProfit;
            datetime time = od[j].orderTime;
            string symbol = od[j].symbol;
            double volume = od[j].volume;
            string type = od[j].type;

            string data ="Deletion Order,"+(string)ticket+","+(string)magicNo+","+(string)openPrice+","+(string)sl+","+(string)tp+","+(string)time+","+(string)symbol+","+(string)volume+","+(string)type;
            Print(data);
            
            removeFromSructure(od[j].orderTicket);
            Socket_Send(My_Socket_Handle,data);
           }

        }




     }




  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckOrderOpenPending()
  {

   ulong ticket;
   ulong orderticket;
   for(int j=0; j<totalObject; j++)
     {

      if(od[j].orderTicket != -1)
        {
         bool found1 = false;
         bool found2 = false;
         ticket = od[j].orderTicket;
         long id  = od[j].posid;
         //  Print("in function ",ticket);

         for(int i=0; i < PositionsTotal(); i++)
           {
            ulong Positionticket = PositionGetTicket(i);
            ulong pid = PositionGetInteger(POSITION_IDENTIFIER);
            if(Positionticket == ticket)
              {
               found1 = true;
              }
            //if(pid == id)
            //  {
            //   found1 = true;
            //  }
           }

         for(int i=0; i <  OrdersTotal(); i++)
           {
            orderticket = OrderGetTicket(i);

            if(orderticket == ticket)
              {
               found2 = true;
              }
           }


         // Print(found1,found2);
         if(found1 == false && found2 == false)
           {
            //    Print("ticket is closed :");

            ulong  ticket = od[j].orderTicket;
            long magicNo = od[j].magicNo;
            double openPrice = od[j].price;
            double sl = od[j].stopLoss;
            double tp = od[j].takeProfit;
            datetime time = od[j].orderTime;
            string symbol = od[j].symbol;
            double volume = od[j].volume;
            string type = od[j].type;

            string data ="Deletion Order,"+(string)ticket+","+(string)magicNo+","+(string)openPrice+","+(string)sl+","+(string)tp+","+(string)time+","+(string)symbol+","+(string)volume+","+(string)type;
            Print(data);
            removeFromSructure(od[j].orderTicket);
            Socket_Send(My_Socket_Handle,data);
           }

        }




     }




  }


//|                                                                  |
//+------------------------------------------------------------------+
void removeFromSructure(ulong ticket)
  {
   for(int j=0; j<totalObject; j++)
     {
      if(od[j].orderTicket == ticket)
        {
         od[j].orderTicket = -1;
         od[j].magicNo     = -1;
         od[j].price       = -1;
         od[j].stopLoss    = -1;
         od[j].takeProfit  = -1;
         od[j].orderTime   = -1;
         od[j].symbol      = "";
         od[j].volume      = -1;
         od[j].type        = "";
        }
     }

   for(int j=0; j<totalObject; j++)
     {
      if(Mod[j].orderTicket == ticket)
        {
         Mod[j].orderTicket = -1;
         Mod[j].magicNo     = -1;
         Mod[j].price       = -1;
         Mod[j].stopLoss    = -1;
         Mod[j].takeProfit  = -1;
         Mod[j].orderTime   = -1;
         Mod[j].symbol      = "";
         Mod[j].volume      = -1;
         Mod[j].type        = "";
        }
     }
//  Print("Ticket Removed from structure and closed :: ",ticket);

  }



//+------------------------------------------------------------------+

//+------------------------------------------------------------------+





int Socket_Connect()
{
  int h_socket = SocketCreate(SOCKET_DEFAULT);
  
  if(h_socket != INVALID_HANDLE)
  {
     if(SocketConnect(h_socket,"127.0.0.1",9090,2000))
     {
      Print("Connected to Socket Server"); 
      
     
     }//if(SocketConnect
     else
     {
      Print("Fail connected to Socket Server. error code : ", GetLastError()); 
     }
  
  
  }//if(socket != INVALID_HANDLE)
  else
  {
   Print("Fail SocketCreate error code : ", GetLastError()); 
  }
  
  return h_socket; 
}

void Socket_Close(int socket_handle)
{
   if(socket_handle != INVALID_HANDLE)
   {
      SocketClose(socket_handle);
      My_Socket_Handle = INVALID_HANDLE; 
      Print("Socket Closed");      
   }

}

int Socket_Send(int socket_handle,string str_data)
{
   if(socket_handle == INVALID_HANDLE) return 0; 
   
   uchar bytes[]; 
   int byte_size = StringToCharArray(str_data,bytes)-1; 
   
   return SocketSend(socket_handle,bytes,byte_size);
      
}