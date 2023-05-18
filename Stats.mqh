//+------------------------------------------------------------------+
//|                                                        Stats.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

void PrintArray(const double& array[])
{
    Print("Start");
    int array_size = ArraySize(array);
    for(int i = 0; i < array_size; i++)
    {
    Print(array[i]);
    }
    Print("End");
}




double ArrayMean(const double& array[])
{
    int array_size = ArraySize(array);
    double sum = 0;
    for(int i = 0; i < array_size; i++)
    {
        sum += array[i];
    }
    return sum/array_size;
}

void MovingAverage(const double& array[], const int period, double& ma_array[])
{
    int array_size = ArraySize(array);
    int ma_size = array_size - period + 1;
    for(int i = 0; i < ma_size; i++)
    {
        double sum = 0;
        for(int j = i; j < i + period; j++)
        {
            sum += array[j];
        }
        ma_array[i] = sum/period;
    }
}

void WeightedMovingAverage(const double& array[], const int period, const double& weights[], double& wma_array[])
{
    int array_size = ArraySize(array);
    int wma_size = array_size - period + 1;
    for(int i = 0; i < wma_size; i++)
    {
        double sum = 0;
        double weight_sum = 0;
        for(int j = i; j < i + period; j++)
        {
            sum += array[j] * weights[j - i];
            weight_sum += weights[j - i];
        }
        wma_array[i] = sum/weight_sum;
    }
}

void ExponentialMovingAverage(const double& array[], const int period, const double& smoothing_factor, double& ema_array[])
{
    int array_size = ArraySize(array);
    double ema = array[array_size - period];
    ema_array[0] = ema;
    for(int i = array_size - period + 1, j = 1; i < array_size; i++, j++)
    {
        ema = array[i] * smoothing_factor + ema * (1 - smoothing_factor);
        ema_array[j] = ema;
    }
}

void PercentageChange(double& array[], double& output[]) 
{
    int array_size = ArraySize(array);
    for(int i = 0; i < array_size-1; i++) {
        output[i]=array[i+1]/array[i]-1;
    }
}


double ArrayStandardDeviation(const double& array[]) 
{
   
    int array_size = ArraySize(array);
    double mean = ArrayMean(array);
    double sum = 0;
        
    
    for(int i = 0; i<array_size;i++){
      sum+=pow(array[i]-mean,2);
    }
    return sqrt(sum/(array_size));

}

void StandardDeviation(const double& array[], double& output[], int num_periods) 
{
    int array_size = ArraySize(array);
    for(int i = 0; i < array_size - num_periods+1;i++){
      double current[];
      ArrayResize(current,num_periods);
      ArrayCopy(current,array,0,i,num_periods);
      output[i]=ArrayStandardDeviation(current);
    }
}

double ArrayVariance(const double& array[])
{
   return pow(ArrayStandardDeviation(array),2);
}

void Variance(const double& array[], double& output[], int num_periods) 
{
    int array_size = ArraySize(array);
    for(int i = 0; i < array_size - num_periods+1;i++){
      double current[];
      ArrayResize(current,num_periods);
      ArrayCopy(current,array,0,i,num_periods);
      output[i]=ArrayVariance(current);
    }
}


double MeanSquaredError(const double& actual[], const double& predicted[]) {

    int array_size = ArraySize(actual);
    
    double sum = 0.0;
    for(int i = 0; i < array_size; i++) {
        sum += pow(actual[i] - predicted[i], 2);
    }

    double mse = sum / array_size;
    return mse;
}


