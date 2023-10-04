load_libs(c("readxl","plotly","scales"))

#SET PATH FOR INPUT AND OUTPUT FILES
path <- "C:/Users/marce/Documents/Python/SWD/Challenges/OCT 2023/"

#GET DATA
rates <- read_excel(paste0(path, "OCT 2023 Challenge.xlsx"), sheet="Sheet1")
rates$inflation_annual <- rates$inflation_annual/100
rates$fedfunds <- rates$fedfunds/100

#PLOT INFLATION RATES OVER TIME
fig <- plot_ly(rates, x=~timeperiod, y=~inflation_annual, name='Inflation', width=1200, height=600,
               type='scatter', mode='lines', line=list(color='rgb(205, 12, 24)', width=4))

#PLOT FED FUNDS RATES OVER TIME
fig <- fig %>% add_trace(y=~fedfunds, name='Fed Funds', fill='tonexty', fillcolor="floralwhite",
                         line=list(color='rgb(22, 96, 167)', width=4))

# ADD TITLE, FORMAT AXES AND HOVER TEXT, ADD GRAY BOXES, SET MARGINS
fig <- fig %>% layout(title=list(text="<b>Do Adjustments in the Fed Funds Rate Really Affect Inflation?</b>", 
                                 font=list(size=24)),
                      xaxis=list(title="", showgrid=FALSE),
                      yaxis=list (title="", range=c(-0.005, 0.11), dtick=0.05, tickformat=".0%", 
                                    hoverformat=".2%", griddash="dash", gridcolor="rgb(240,240,240)"),
                      showlegend=FALSE,
                      shapes = list(list(type="rect", text='', fillcolor="gray", line=list(color="gray"),
                                         opacity=0.2, y0=0, y1=0.05, x0='2014-10-01', x1='2015-04-01', 
                                         layer='below'),
                                    list(type="rect", text='', fillcolor="gray", line=list(color="gray"),
                                         opacity=0.2, y0=0, y1=0.05, x0='2020-03-01', x1='2020-05-01',
                                         layer='below')),
                      margin=list(l=50, r=50, b=120, t=80, pad=3))

#ADD LABELS ON LINES TO AVOID THE NEED FOR A LEGEND
fig <- fig %>% add_annotations(text="<b>Inflation</b>", font=list(color="rgb(205, 12, 24)"), showarrow=FALSE,
                               x=rates$timeperiod[3], y=rates$inflation_annual[2]+0.003)

fig <- fig %>% add_annotations(text="<b>Fed Funds</b>", font=list(color="rgb(22, 96, 167)"), showarrow=FALSE,
                               x=rates$timeperiod[3], y=rates$fedfunds[2]+0.003)

#ADD ANNOTATION AT HIGHEST POINT
fig <- fig %>% add_annotations(text="<b>Highest rate of inflation since November 1981</b>", font=list(color="darkgray"), 
                               showarrow=TRUE, arrowhead=2, arrowcolor="darkgray", arrowsize=0.5,
                               x=rates$timeperiod[114], y=rates$inflation_annual[114])

#ADD ANNOTATION TO EXPLAIN GRAY BOXES
fig <- fig %>% add_annotations(text="<b>COVID-19<br>Pandemic Begins</b>", font=list(color="darkgray"), 
                               showarrow=FALSE, x=rates$timeperiod[88], y=0.055)

fig <- fig %>% add_annotations(text="<b>Oil Prices<br>Drop Dramatically</b>", font=list(color="darkgray"), 
                               showarrow=FALSE, x=rates$timeperiod[25], y=0.055)

#ADD ANNOTATIONS TO THE THREE TIME PERIODS
fig <- fig %>% add_annotations(text="The inflation rate <b>dropped</b> <br>due to external factors.", 
                               font=list(color="darkgray", size=10), showarrow=FALSE, 
                               xref="paper",yref="paper", yanchor="bottom", x=0.05, y=-0.15)

fig <- fig %>% add_annotations(text="The inflation rate <b>did not drop</b> significantly <br>despite increases in the Fed Funds rate.", 
                               font=list(color="darkgray", size=10), showarrow=FALSE, 
                               xref="paper",yref="paper", yanchor="bottom", x=0.48, y=-0.15)

fig <- fig %>% add_annotations(text="The inflation rate <b>dropped</b> over a<br> period when the Fed Funds rate was increased.", 
                               font=list(color="darkgray", size=10), showarrow=FALSE, 
                               xref="paper",yref="paper", yanchor="bottom", x=0.92, y=-0.15)

#ADD ANNOTATION FOR SOURCES FOOTNOTE
fig <- fig %>% add_annotations(text="Sources: <a href='https://www.usinflationcalculator.com/inflation/current-inflation-rates/'>Inflation data</a> and <a href='https://fred.stlouisfed.org/series/FEDFUNDS'>Fed Funds rate</a>.", 
                               font=list(color="darkgray", size=9), showarrow=FALSE, 
                               xref="paper",yref="paper", yanchor="bottom", x=0, y=-0.24)

#WRITE OUT TO AN HTML FILE
htmlwidgets::saveWidget(as_widget(fig), paste0(path, "Annotations on a Graph.html"))
fig
