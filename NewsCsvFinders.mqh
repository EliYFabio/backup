//+------------------------------------------------------------------+
//|                                               NewsCsvFinders.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+


bool GetSymbolsOnNews(string csvfile,bool onlyhigh, datetime Newsdate, string &array[])
{
    // Abrir el archivo CSV
    int fileHandle = FileOpen(csvfile, FILE_CSV|FILE_READ);
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Error al abrir el archivo CSV: ", GetLastError());
        return false;
    }
    
    int counter=0;
    
    
    // Leer el archivo CSV línea por línea
    string line;
    int lineCount = 0;
    while(FileIsEnding(fileHandle) == false)
    {
        // Leer la siguiente línea del archivo CSV
        line = FileReadString(fileHandle, CHAR_MAX);
        
        // Incrementar el contador de líneas
        lineCount++;
        
        // Saltar la primera línea si es un encabezado
        if(lineCount == 1 )
        {
            continue;
        }
        
        string cell[4];
        
        StringSplit(line,',',cell);
        // Obtener la fecha de la columna 3
        string dateString = cell[2];
        
        
        // Convertir la fecha en formato `YYYY.MM.DD HH:MM:SS` a Unix timestamp
        datetime date = StrToTime(dateString);
        
        if(date==Newsdate){
        if (onlyhigh){
        if (cell[3]=="High"){
        ArrayResize(array,counter+1,5);
            array[counter]=cell[1];
            counter+=1;
        }
        }
        else{
            ArrayResize(array,counter+1,5);
            array[counter]=cell[1];
            counter+=1;
            }
        }
        if(date>Newsdate){
        continue;
        }
        
    }
    
    // Cerrar el archivo CSV
    FileClose(fileHandle);
    
    return true;  

}



datetime FindNearestFutureDate(string csvfile,bool onlyhigh, datetime currentTime)
{
    // Abrir el archivo CSV
    
    int fileHandle = FileOpen(csvfile, FILE_CSV|FILE_READ);
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Error al abrir el archivo CSV: ", GetLastError());
        return 0;
    }
    
    // Variables para almacenar la fecha más cercana encontrada
    datetime nearestDate = 0;
    string nearestDateString = "";
    
    // Leer el archivo CSV línea por línea
    string line;
    int lineCount = 0;
    while(FileIsEnding(fileHandle) == false)
    {
        // Leer la siguiente línea del archivo CSV
        line = FileReadString(fileHandle, CHAR_MAX);
        
        // Incrementar el contador de líneas
        lineCount++;
        
        // Saltar la primera línea si es un encabezado
        if(lineCount == 1 )
        {
            continue;
        }
        string cols[4];
        StringSplit(line,',',cols);
        // Obtener la fecha de la columna 3
        string dateString = cols[2];
        
        // Convertir la fecha en formato `YYYY.MM.DD HH:MM:SS` a Unix timestamp
        datetime date = StrToTime(dateString);
        
        // Verificar si la fecha es mayor que el tiempo actual y es la primera fecha mayor encontrada,
        // o si la fecha es mayor que el tiempo actual y es más cercana que la fecha anteriormente encontrada
        if(date > currentTime && (nearestDate == 0 || date < nearestDate ))
        {
        if (onlyhigh){
        if (cols[3]=="High"){
        
            nearestDate = date;
            nearestDateString = dateString;
            continue;
            }
        }
        else{
            nearestDate = date;
            nearestDateString = dateString;
            continue;
            }
        }
    }
    
    // Cerrar el archivo CSV
    FileClose(fileHandle);
    
    // Verificar si se encontró alguna fecha mayor que la actual
    if(nearestDate != 0)
    {
        // Retornar la fecha más cercana en formato Unix timestamp
        return nearestDate;
    }
    
    // Si no se encontró ninguna fecha mayor que la actual, retornar 0
    return 0;
}




