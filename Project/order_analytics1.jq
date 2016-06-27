jsoniq version "1.0";
module namespace ns = "http://cs.gmu.edu/dgal/orderAnalytics.jq";
import module namespace np = "http://cs.gmu.edu/dgal/Gaussian.jq"at"./gaussian.jq";

import module namespace xs = "http://www.w3.org/2005/xpath-functions";


declare function ns:orderAnalytics($purchase)
{
    let $supInfo := $purchase
    let $suppliers := $supInfo.sup

    let $perSup := [
        for $s in $suppliers
            let $si := $supInfo[$$.sup = $s]
          (:  let $ppu:= $si.ppu + Gausian({mean:0.0,sigma:0.05*$si.ppu}):)
            let $priceBeforeDisc :=  sum( for $i in $si.items[]
                                        return $i.ppu*$i.avgMiles div $i.mileage)
          (:  let $priceAfterDisc := $priceBeforeDisc

            let $priceAfterDisc := sum(let $bound := $si.volumeDiscOver
                                       let $disc := $si.volumeDiscRate
                                       return dgal:PiecewiseExpr([{slope: 1, breakpoint: $bound}], 1 - $disc, 0, 0, $priceBeforeDisc))
            :)
            return {sup: $s, items: $si.items[], priceBeforeDisc: $priceBeforeDisc}
    ]
    let $totalCost := sum(for $s in $perSup[] return $s.priceBeforeDisc)
  (:  let $supAvailability :=

        every $i in $supInfo.items[] satisfies $i.qty <= $i.availQty
    let $demandSatisfied :=
        every $i in $orderedItems satisfies $i.demQty <= sum(for $it in $supInfo.items[]
                                                                  where $it.item = $i.item
                                                                  return $it.qty)
    let $constraints := $supAvailability and $demandSatisfied:)
   return {
        perSup: $perSup,
        quaterlyCost: $totalCost

           }
};




declare function ns:future($purchase)
{
  let $mus:= $purchase.mu
  let $sigmas := $purchase.sigma
  let $random := np:gaussian($mus,$sigmas)

  let $currentprice := for $s in $purchase.purchase[]
                          where $s.Month ="January"
                                 for $i in $s.items[]
                                      where $i.item = 1
                                      return ($i.ppu div $i.mileage*$i.avgMiles) div 10

  let $totalfutureprice := for $s in $purchase.purchase[]
                          where $s.Month ="January"
                                 for $i in $s.items[]
                                      where $i.item = 1
                                      return (($i.ppu div $i.mileage*$i.avgMiles) + $currentprice)



return{futureprice:$currentprice, totalfutureprice: $totalfutureprice}
};
declare function ns:option($purchase)
{
  let $mus:= $purchase.mu
  let $sigmas := $purchase.sigma
  let $random := np:gaussian($mus,$sigmas)
  let $optionprice := for $s in $purchase.purchase[]
                          where $s.Month ="January"
                                 for $i in $s.items[]
                                      where $i.item = 1
                                      return (($i.ppu div $i.mileage*$i.avgMiles) * 8) div 100

  let $totaloptionprice := for $s in $purchase.purchase[]
                          where $s.Month ="January"
                                 for $i in $s.items[]
                                      where $i.item = 1
                                      return (($i.ppu div $i.mileage*$i.avgMiles) + $optionprice)



return{optionprice:$optionprice, totaloptionprice: $totaloptionprice}
};


declare function ns:QfutureOrOption($purchase)
{
  let $mu:= 0.00
  let $sigma := 0.05
  let $gs:= np:gaussian($mu,$sigma)
  let $Mode:=$purchase.SItem.Item
  let $priceformonth  := for $s in $purchase.Requirement
                                 for $i in $s.items[]
                                    where $i.item = $Mode
                                    return {Month:$s.Month,price:$i.ppu div $i.mileage*$i.avgMiles}



let $priceper := for $s in $purchase.purchase[]
                   where $s.Month eq $purchase.PMonth.Month
                   for $i in $s.items[]
                        where $i.item = $Mode
                        let $ppu:= $i.ppu + $gs
                     return {Month:$s.Month,price:$ppu div $i.mileage*$i.avgMiles}



let $result  := if($priceformonth.price gt $priceper.price)
                            then "Option"
                            else "Future"


return {CurrentMonth_cost:$priceformonth,PriceforGivenMonth:$priceper,Result:$result}
};


declare function ns:QuarterMinimum($purchase)
{
  let $mu:= 0.00
  let $sigma := 0.05
  let $gs:= np:gaussian($mu,$sigma)
  let $Mode:=$purchase.SItem.Item
  let $priceformonth  := for $s in $purchase.Requirement
                                 for $i in $s.items[]
                                    where $i.item = $Mode
                                    return {Month:$s.Month,price:$i.ppu div $i.mileage*$i.avgMiles}



  let $priceper := for $s in $purchase.purchase[]
                    where $s.Month = $purchase.QMonth.Months[].Month
                         for $i in $s.items[]
                        where $i.item =$Mode
                        let $ppu:= $i.ppu + $gs
                        return {Month:$s.Month,Cost:$ppu div $i.mileage*$i.avgMiles}

  let $costofmonth:= for $i in $priceper
                     return [$i.Cost]

  let $mini := xs:min((for $mn in $costofmonth[] return $mn))
  let $minMonth:= for $i in $priceper
                where $mini eq $i.Cost
                return $i.Month


  let $result  := if($priceformonth.price gt $mini)
                            then "Option"
                            else "Future"


  return {CurrentMonth:$priceformonth, CostforEachMonth:$priceper,MinimumCost:$mini,For:$minMonth,Result:$result}

};
declare function ns:HalfYearMinimum($purchase)
{
  let $mu:= 0.00
  let $sigma := 0.05
  let $gs:= np:gaussian($mu,$sigma)
  let $Mode:=$purchase.SItem.Item
  let $priceformonth  := for $s in $purchase.Requirement
                                 for $i in $s.items[]
                                    where $i.item = $Mode
                                    return {Month:$s.Month,price:$i.ppu div $i.mileage*$i.avgMiles}



  let $priceper := for $s in $purchase.purchase[]
                    where $s.Month = $purchase.TimePeriod.Months[].Month
                         for $i in $s.items[]
                        where $i.item =$Mode
                        let $ppu:= $i.ppu + $gs
                        return {Month:$s.Month,Cost:$ppu div $i.mileage*$i.avgMiles}

let $costofmonth:= for $i in $priceper
                     return [$i.Cost]

let $mini := xs:min((for $mn in $costofmonth[] return $mn))
let $minMonth:= for $i in $priceper
                where $mini eq $i.Cost
                return $i.Month


  let $result  := if($priceformonth.price gt $mini)
                            then "Option"
                            else "Future"


return {CurrentMonth:$priceformonth, CostforEachMonth:$priceper,MinimumCost:$mini,For:$minMonth,Result:$result}
};

declare function ns:YearMinimum($purchase)
{
  let $mu:= 0.00
  let $sigma := 0.05
  let $gs:= np:gaussian($mu,$sigma)
  let $Mode:=$purchase.SItem.Item
  let $priceformonth  := for $s in $purchase.Requirement
                                 for $i in $s.items[]
                                    where $i.item = $Mode
                                    return $i.ppu div $i.mileage*$i.avgMiles



let $priceper := for $s in $purchase.purchase[]
                   for $i in $s.items[]
                        where $i.item = $Mode
                        let $ppu:= $i.ppu + $gs
                        return {Month:$s.Month,Cost:$ppu div $i.mileage*$i.avgMiles}

let $costofmonth:= for $i in $priceper
                     return [$i.Cost]

let $mini := xs:min((for $mn in $costofmonth[] return $mn))
let $minMonth:= for $i in $priceper
                where $mini eq $i.Cost
                return $i.Month


let $result  := if($priceformonth gt $mini)
                            then "Option"
                            else "Future"

return {CurrentMonth:$priceformonth, CostforEachMonth:$priceper,MinimumCost:$mini,For:$minMonth,Result:$result}
};
