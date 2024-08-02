//
//  HistoricalView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/30/24.
//

import SwiftUI

struct HistoricalView: View {
    @State var chartsModel: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var ticker: String = ""
    var color: String = ""
    
    init(ticker: String) {
        self.ticker = ticker
    }
    
    var highchartsContent: String {
    """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Highcharts Example</title>
    <script src="https://code.highcharts.com/stock/highstock.js"></script>
    <script src="https://code.highcharts.com/stock/indicators/indicators.js"></script>
    <script src="https://code.highcharts.com/stock/indicators/volume-by-price.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    </head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <body>
    <div id="container" style="height:400px;"></div>
    <script>
    Highcharts.chart('container', {
    
        rangeSelector: {
          buttons: [{
            type: 'month',
            count: 1,
            text: '1m',
            title: 'View 1 month'
        }, {
            type: 'month',
            count: 3,
            text: '3m',
            title: 'View 3 months'
        }, {
            type: 'month',
            count: 6,
            text: '6m',
            title: 'View 6 months'
        }, {
            type: 'ytd',
            text: 'YTD',
            title: 'View year to date'
        }, {
            type: 'year',
            count: 1,
            text: '1y',
            title: 'View 1 year'
        }, {
            type: 'all',
            text: 'All',
            title: 'View all'
        }],
        selected: 6,
        enabled: true
        },
    
        title: {
        text: `\(self.ticker) Historical`,
        align: 'center'
        },
    
        subtitle: {
          text: 'With SMA and Volume by Price technical indicators'
        },
    
          xAxis: {
            type: 'datetime',
          },
    
        yAxis: [{
          startOnTick: false,
          endOnTick: false,
          opposite: true,
          labels: {
              align: 'right',
              x: -3
          },
          title: {
              text: 'OHLC'
          },
          height: '60%',
          lineWidth: 2,
          resize: {
              enabled: true
          }
        }, {
          opposite: true,
          labels: {
              align: 'right',
              x: -3
          },
          title: {
              text: 'Volume'
          },
          top: '65%',
          height: '35%',
          offset: 0,
          lineWidth: 2
        }],
    
        tooltip: {
          split: true
        },
    
          plotOptions: {
            series: {
                label: {
                    connectorAllowed: false
                },
                marker: {
                  enabled: false
                },
                pointStart: 2010
            }
          },
          series: [
            {
              name: '\(self.ticker)',
              type: 'candlestick',
              data: \(chartsModel.ohlc),
              id: `\(self.ticker)`,
            },
            {
              type: 'column',
              name: 'Volume',
              id: 'volume',
              data: \(chartsModel.vol),
              yAxis: 1
            },
            {
              type: 'vbp',
              linkedTo: `\(self.ticker)`,
              params: {
                  volumeSeriesID: 'volume'
              },
              dataLabels: {
                  enabled: false
              },
              zoneLines: {
                  enabled: false
              }
            },
            {
              type: 'sma',
              linkedTo: `\(self.ticker)`,
              zIndex: 1,
              marker: {
                  enabled: false
              }
            }
          ],
          navigator: {
            enabled: true
          },
          legend: {
            enabled: false
          }
    });
    </script>
    </body>
    </html>
    """
    }

    var body: some View {
        VStack {
            if (isLoading == true) {
//                Spacer()
//                HStack {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                }
//                Text("Fetching Data...")
//                .padding(5)
//                .foregroundStyle(.secondary)
//                Spacer()
            }
            else {
                HighchartsView(htmlContent: highchartsContent)
                            .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear() {
            isLoading = true
            chartsModel.fetchHistoryData(ticker: ticker)
            {
                isLoading = false
            }
        }
    }

}

#Preview {
    HistoricalView(ticker: "TSLA")
        .environment(ChartsModel())
}
