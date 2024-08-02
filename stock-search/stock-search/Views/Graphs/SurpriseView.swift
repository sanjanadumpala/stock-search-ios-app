//
//  SurpriseView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/30/24.
//

import SwiftUI

struct SurpriseView: View {
    @State var chartsModel: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var ticker: String = ""
    init(ticker: String) {
        self.ticker = ticker
    }
    
    var highchartsContent: String {
    """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Highcharts Example</title>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/export-data.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    </head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <body>
    <div id="container" style="height:400px"></div>
    <script>
    Highcharts.chart('container', {
      chart: {
          type: 'spline',
      },
      title: {
          text: 'Historical EPS Surprises',
          align: 'center'
      },

      xAxis: {
        categories: \(chartsModel.title),
        accessibility: {
            rangeDescription: 'Range: last 4 months'
        },
        maxPadding: 0.05,
      },

      yAxis: {
          title: {
              text: 'Quaterly EPS'
          },
          labels: {
              format: '{value}'
          },
          accessibility: {
              rangeDescription: 'Range: 0 to 1'
          },
      },

      legend: {
          enabled: true
      },

      tooltip: {
          shared: true
      },

      plotOptions: {
          spline: {
              marker: {
                  enabled: true
              }
          }
      },

      series: [{
        type: "spline",
        name: 'Actual',
        data: \(chartsModel.actual)
      },{
        type: "spline",
        name: 'Estimate',
        data: \(chartsModel.estimate)
      }],
    });
    </script>
    </body>
    </html>
    """
    }

    var body: some View {
        VStack {
            if (isLoading == false) {
                HighchartsView(htmlContent: highchartsContent)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear() {
            isLoading = true
            chartsModel.fetchEarnings(ticker: ticker)
            {
                isLoading = false
            }
        }
    }

}

#Preview {
    SurpriseView(ticker: "TSLA")
        .environment(ChartsModel())
}
