# StopLoss-PartialProfit-Manager

This MQL5 Expert Advisor seeks to maintain consistent risk management in my personal Foreign Exchange Trading while also closing partial profits throughout.

**I AM NOT LIABLE FOR ANY PROFIT OR LOSS YOU MAY INCUR USING THIS EA**
**MINIMUM 0.1 LOT SIZES FOR THIS EA TO WORK**

## Description

The EA takes inputs in for your points in pips in which you want to take profits at as well as what amount of your lot size you wish to close at these points. It also visually marks on the chart where this will be occuring and as a line passes it will be deleted. The Stop Loss will automatically be set to break even  +/- an offset in pips at the first Take Profit close. The EA can detect exisiting trades that have been placed before it has run and will close accordingly. When setting your positions while using this EA, be sure to set your final take profit point as your take profit in your position - the EA will do the rest.


## Getting Started

### Dependencies

* MetaTrader 5
* A Live or Demo Account with an MetaTrader 5 Supported Broker

### Installing

* This EA can be cloned using:
```
git clone https://github.com/mghaby/StopLoss-PartialProfit-Manager.git
```
* The source code can also be copied and pasted directly into a template file in the MetaTrader 5 IDE and compiled to avoid glitches in the MetaTrader 5 software

### Executing program

1. Once cloned place the source code file and the compiled `.ex5` into the `/Experts` directory in your MetaTrader 5 installation
2. In the main MetaTrader 5 panel once logged in with a broker you can access the strategy tester in which you can follow the prompts to test this EA

## Help

`Inside the MetaTrader 5 IDE, you can highlight anything and press ``F2`` for more details`

## Authors

1. Mark Ghaby
  * [Github](https://github.com/mghaby)
  * [LinkedIn](https://www.linkedin.com/in/mghaby/)

## Version History

* 0.2
    * Added Support For Weekend Close

* 0.1
    * Initial Release


## License

This project is licensed under the GNU General Public License - see the LICENSE file for details

## Acknowledgments

* [README-Template](https://gist.github.com/DomPizzie/7a5ff55ffa9081f2de27c315f5018afc)