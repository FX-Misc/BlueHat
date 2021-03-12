#include "Graphics.mqh"

void Graphics::DisplayVert(string s, datetime t, double p)
{
//bool LabelCreate(
//            datetime t,
//            double p,
//                 const long              chart_ID=0,// ID des Charts 
//                 const string            name="LabelT",             // Name des Labels 
//                 const int               sub_window=0,             // Nummer des Unterfensters 
//                 const int               x=0,                      // X-Koordinate 
//                 const int               y=50,                      // Y-Koordinate 
//                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_LOWER, // Winkel des Charts zu Binden 
//                 const string            text="Labelmy",             // Text 
//                 const string            font="Arial",             // Schrift 
//                 const int               font_size=20,             // Schriftgröße 
//                 const color             clr=clrRed,               // Farbe 
//                 const double            angle=0.0,                // Text Winkel 
//                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_LOWER, // Bindungsmethode 
//                 const bool              back=false,               // Im Hintergrund 
//                 const bool              selection=true,          // Wählen um zu bewegen 
////                 const bool              hidden=true,              // Ausgeblendet in der Objektliste 
//                 const bool              hidden=false,              // Ausgeblendet in der Objektliste 
//                 const long              z_order=0)                // Priorität auf Mausklick 
//  {
////--- Setzen den Wert des Fehlers zurück 
//   ResetLastError();
    string name = "testname";
    if(!ObjectCreate(0,name,OBJ_TEXT,0,t,p))
        Print(__FUNCTION__,":failed to create object = ",GetLastError());
    else
    {
        ObjectSetString(0,name,OBJPROP_TEXT,s);
        //   ObjectSetString(chart_ID,name,OBJPROP_FONT,"Arial");
        ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
        ObjectSetDouble(0,name,OBJPROP_ANGLE,90);
        ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);
        ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
        //   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
        ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);
        ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
        //   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
        //   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
    }
    return;
}

void Graphics::DisplyHor(string s, datetime t, double p)
{
}

void Graphics::Clear()
{
}
