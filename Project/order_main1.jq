jsoniq version "1.0";
import module namespace ns = "http://cs.gmu.edu/dgal/orderAnalytics.jq"
at "./order_analytics1.jq";

let $purchase := (
    { Month: "January",
      items: [
        { item: 1, ppu: 2.78,  mileage:16, avgMiles:1000, quantity: 63}
      ]
    },
    { Month: "February",
      items: [
        { item: 1, ppu: 2.58, mileage:16, avgMiles: 999, quantity: 62 }
      ]
    },
    { Month: "March",
      items: [
        { item: 1, ppu: 2.87,  mileage:16, avgMiles:1000, quantity: 62  }
      ]
    },
    { Month: "April",
      items: [
        { item: 1, ppu: 2.78,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "May",
      items: [
        { item: 1, ppu: 2.59, mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "June",
      items: [
        { item: 1, ppu: 2.50,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "July",
      items: [
        { item: 1, ppu: 2.51,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "August",
      items: [
        { item: 1, ppu: 2.46,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "September",
      items: [
        { item: 1, ppu: 2.31,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "October",
      items: [
        { item: 1, ppu: 2.143,  mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },
    { Month: "November",
      items: [
        { item: 1, ppu: 1.99, mileage:16, avgMiles:1000, quantity: 62 }
      ]
    },

    { Month: "December",
      items: [
        { item: 1, ppu: 2.78,  mileage:16,avgMiles:1000, quantity:62 }
      ]
    }
    )




let $SItem := ({Item:1})
let $demand := (
    { item: 4, fuel: 63 },
    { item: 2, fuel: 62 },
    { item: 3, fuel: 62 },
    { item: 4, fuel: 62 })
let $FirstHalf:= ({Months:[{Month:"January"},{Month:"February"},{Month:"March"},{Month:"April"},{Month:"May"},{Month:"June"}]})
let $SecondHalf:= ({Months:[{Month:"July"},{Month:"August"},{Month:"September"},{Month:"October"},{Month:"November"},{Month:"December"}]})
let $Q1Month:= ({Months:[{Month:"January"},{Month:"February"},{Month:"March"}]})
let $Q2Month:= ({Months:[{Month:"April"},{Month:"May"},{Month:"June"}]})
let $Q3Month:= ({Months:[{Month:"July"},{Month:"August"},{Month:"September"}]})
let $Q4Month:= ({Months:[{Month:"October"},{Month:"November"},{Month:"December"}]})
let $PMonth:=({Month:"October"})
let $requirement := (
    { Month: "CurrentMonth",
      items: [
        { item: 1, ppu: 2.78,  mileage:16, avgMiles:1000, quantity: 63}
      ]
    })
    let $mu:= 0.00
    let $sigma := 0.05

    return ns:YearMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,Requirement:$requirement})

    (:
    return ns:YearMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,Requirement:$requirement})
    :)

    (:
    return ns:HalfYearMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,TimePeriod:$FirstHalf,Requirement:$requirement})
    :)
    (:
    return ns:HalfYearMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,TimePeriod:$SecondHalf,Requirement:$requirement})
    :)
    (:
    return ns:QuarterMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,QMonth:$Q1Month,Requirement:$requirement})
    :)
    (:
    return ns:QuarterMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,QMonth:$Q2Month,Requirement:$requirement})
    :)
    (:
    return ns:QuarterMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,QMonth:$Q3Month,Requirement:$requirement})
    :)
    (:
    return ns:QuarterMinimum({purchase: $purchase, mu: $mu,sigma: $sigma, SItem:$SItem ,QMonth:$Q4Month,Requirement:$requirement})
    :)
    (:
    return ns:QfutureOrOption({purchase: $purchase, mu: $mu,sigma: $sigma,PMonth:$PMonth,SItem:$SItem,Requirement:$requirement})
    :)
