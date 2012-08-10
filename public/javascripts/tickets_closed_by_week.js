$(document).ready(function() {
  function displayChart(dates, series) {
    var chart = new Highcharts.Chart({
      chart: {
        renderTo: 'content',
        type: 'line',
        marginRight: 130,
        marginBottom: 25
      },
      title: {
        text: 'Tickets Closed by Week',
        x: -20 //center
      },
      xAxis: {
        categories: dates
      },
      yAxis: {
        title: {
          text: 'Number of Tickets Closed'
        },
        plotLines: [{
          value: 0,
          width: 1,
          color: '#808080'
        }]
      },
      tooltip: {
        formatter: function() {
          return '<b>'+ this.series.name +'</b><br/>'+
          this.x +': '+ this.y;
        }
      },
      legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'top',
        x: -10,
        y: 100,
        borderWidth: 0
      },
      series: series
    });
  }

  function displayError(message) {
    $("#loading").hide();
    $("<div id='error'>").text(message).appendTo("#container");
  }

  $(".tickets-closed-by-week").click(function() {
    $.ajax({
      url: "/tickets/closed_by_week",
      type: "GET",
      dataType: "json",
      success: function(data) {
        $("#content").empty();
        displayChart(data.dates, data.series);
      },
      error: function() {
        displayError("An unexpected error occurred.");
      }
    });
  });
});
