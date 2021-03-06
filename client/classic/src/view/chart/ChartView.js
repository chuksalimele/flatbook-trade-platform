/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var chartProp = Ext.create('TradeApp.view.chart.ChartProp');
var axes = ChartProp.getAxes();


Ext.define('TradeApp.view.chart.ChartView', {
    extend: 'Ext.Panel',
    xtype: 'chart-view',
    id: 'chart-view-panel',
    requires: [
        'Ext.chart.CartesianChart',
        'Ext.chart.series.*',
        'Ext.chart.interactions.*',
        'Ext.chart.axis.Numeric',
        'Ext.draw.modifier.Highlight',
        'Ext.chart.axis.Time',
        'Ext.chart.interactions.ItemHighlight',
        'TradeApp.store.ChartStore',
        'Ext.dd.DropTarget'
    ],
    layout: 'fit',
    width: '100%',
    height: '100%',
    bodyPadding: 0
    ,
    listeners: {
        afterrender: 'renderHighstock',
        resize: 'redrawHighstock'
    }
    /*,UP COMING FEATURE - UNCOMMENT WHEN FEATURE IS NEEDED
    onBoxReady: function () {
        this.callParent(arguments);
        this.createChartDropTarget(this);
    },
    
    createChartDropTarget: function (cmp) {
        if (this.chartDropTarget) {
            this.destroyChartDropTarget();
        }
        var body = cmp.body;

        this.chartDropTarget = new Ext.dd.DropTarget(body, {
            ddGroup: 'grid-to-chart',
            notifyEnter: function (ddSource, e, data) {
                //Add some flare to invite drop.
                body.stopAnimation();
                body.highlight();
            },
            notifyDrop: function (ddSource, e, data) {

                // Reference the record (single selection) for readability
                var selectedRecord = ddSource.dragData.records[0];
                var symbol = selectedRecord.get('symbol');
                Ext.GlobalEvents.fireEvent('drag_drop_quote_on_chart', symbol);
                return true;
            }
        });

    },
    destroyChartDropTarget: function () {
        var target = this.chartDropTarget;
        if (target) {
            target.unreg();
            this.chartDropTarget = null;
        }

    },
    beforeDestroy: function () {
        this.destroyChartDropTarget();
        this.callParent();
    }

*/
});



