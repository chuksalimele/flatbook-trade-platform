/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */

var _highchartSeries;
var _highcharts;

var _gggg_time = 0;
var _cdata = [];
/*
 setInterval(function () {//TESTING - SIMULATION
 
 console.log('TO BE REMOVE - TESTING DYNAMIC DATA');
 
 _gggg_time++;
 
 var x = (new Date('2018-03-30 00:00:00')).getTime();
 var m = 60000;
 x = x + m * _gggg_time;
 
 if (_highcharts) {
 
 var close = Math.random() * 100;
 
 var pt = [
 x,
 Math.random() * 100,
 Math.random() * 100,
 Math.random() * 100,
 close
 ];
 
 var bars = 100;
 var max = x;
 var min = max - m * bars;
 
 console.log('_highchartSeries.data.length', _highchartSeries.data.length);
 console.log('_highchartSeries.points.length', _highchartSeries.points.length);
 
 if (_highchartSeries.data.length === 0) {
 _cdata.push(pt);
 _highchartSeries.setData(_cdata, true, true);
 } else {
 //_highchartSeries.addPoint(pt, true, true);
 _cdata.push(pt);
 //_highchartSeries.points.update(cdata, true, true);
 _highchartSeries.setData(_cdata, true, true);
 }
 
 _highcharts.xAxis[0].update({tickInterval: m * 4}, true);
 _highcharts.xAxis[0].update({max: max, min: min}, true);
 
 //remove old price line
 _highcharts.yAxis[0].removePlotLine('price_line_id');
 
 //add current price line
 _highcharts.yAxis[0].addPlotLine({
 id: 'price_line_id',
 color: 'red',
 width: 1,
 value: close,
 label: {
 text: '<div style="width: 50px; height: 18px; margin-right: -40px; margin-top: 7px; background-color: red; color: white;">' + close + '</div>',
 align: 'right',
 useHTML: true
 
 },
 });
 }
 }, 10000);
 
 */

Highcharts.setOptions({
    global: {
        useUTC: false
    }
});



var ChartProp = Ext.create('TradeApp.view.chart.ChartProp');
//var util = Ext.create('TradeApp.Util');

Ext.define('TradeApp.view.main.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.main',
    listen: {
        //listen to events using GlobalEvents
        global: {
            account_info: 'onAccountInfo',
            account_modified: 'onAccountModified',
            spotfx_total_positions: 'displayTotalSpotFxPosition',
            options_total_positions: 'displayTotalOptionsPosition',
            price_quote: 'onPriceQuote',
            options_countdown_start: 'onOptionsCountdownStart',
            spotfx_countdown_start: 'onSpotfxCountdownStart',
            options_countdown_over: 'onOptionsCountdownOver',
            spotfx_countdown_over: 'onSpotfxCountdownOver',
            options_pending_order_created: 'onOptionsPendingOrderCreated',
            spotfx_pending_order_created: 'onSpotfxPendingOrderCreated',
            options_pending_order_deleted: 'onOptionsPendingOrderDeleted',
            spotfx_pending_order_deleted: 'onSpotfxPendingOrderDeleted',
            options_trade_closed: 'onOptionsTradeClosed',
            spotfx_trade_closed: 'onSpotfxTradeClosed',
            drag_drop_quote_on_chart: 'onDragDropQuoteOnChart',
            timeframe_quote: 'onTimeframeQuote',
            switch_from_login: 'switchFromLogin'
        }
    },
    _chartSymbol: null,
    _chartTimeframe: null,
    _chartType: 'candlestick',
    _highChartData: {},
    renderHighstock: function () {
        var me = this;
        //alert('renderHighstock');
        var el = document.getElementById('chart-view-panel');
        var container_id = 'highstock_flatbook_container';
        var cont = el.children[0];
        var div = document.createElement('div');
        div.id = container_id;
        div.style = 'position: absolute; top:0px; left:0px; width: 100%; height: 100%; background-color: green;';
        //cont.innerHTML = div;
        if (!document.getElementById(container_id)) {
            cont.appendChild(div);
        }

        //cont.innerHTML = '<div id="' + container_id + '" style="position: absolute; top:0px; left:0px; width: 100%; height: 100%; background-color: green;">'
        //        + '</div>';


        _highcharts = Highcharts.stockChart(container_id, {
            chart: {
                //renderTo: container_id,
                //type: 'ohlc',
                panning: false,
                marginRight: 50,
                spacingRight: 0,
                events: {
                    load: function () {

                        // set up the updating of the chart each second
                        var series = this.series[0];
                        _highchartSeries = series;
                        me.onChartTimeframe();
                    }
                }
            },
            credits: {
                enabled: false
            },
            rangeSelector: {
                //selected: 1,
                enabled: false
            },
            scrollbar: {
                enabled: false
            },
            navigator: {
                enabled: false
            },
            title: {
                //text: ''//come back
            },
            plotOptions: {
                series: {
                    lineWidth: 1,
                    pointWidth: 3
                },
                candlestick: {
                    color: 'black',
                    upColor: 'white',
                    states:{
                        hover:{
                            brightness:0.1,
                            enabled: true,
                            lineWidth: 1// 2 will make it too bold. i don't like that
                        }
                    }
                }
            },
            tooltip:{
                shadow:false,
                valuePrefix:'',
                valueSuffix:''
            },
            xAxis: {
                ordinal: false,
                type: 'datetime',
                gridLineDashStyle: 'dash',
                gridLineWidth: 1,
                gridLineColor: '#bbbbbb'//#C8D3D3
                        //tickInterval: 5 * 60 * 1000,
                        // :40
            },
            yAxis: {
                offset: 50,
                gridLineDashStyle: 'dash',
                gridLineColor: '#bbbbbb',//#C8D3D3
                labels: {
                    formatter: function () {
                        if (me._chartSymbol) {
                            var decimal_places = me.getSymbolDigitCount(me._chartSymbol);
                            return this.value.toFixed(decimal_places);
                        }
                        return this.value;
                    }
                }
            },
            legend: {
                enabled: false
            },
            exporting: {
                enabled: false
            },
            series: [{
                    name: 'Price', //come back
                    type: this._chartType
                }]
        });


    },
    redrawHighstock: function () {
        if (_highcharts) {
            _highcharts.reflow();
        }
    },
    switchFromLogin: function (arg) {
        var dia = this.lookupReference('loginDialog');
        dia.hide();
        if (arg && typeof arg.callback === "function") {
            arg.callback();
        }
    },
    onDragDropQuoteOnChart: function (symbol) {
        this.onChartTimeframe(symbol);
    },
    onTimeframeQuote: function (msg) {

        //console.log(msg);
        TradeApp.Util.addChartTFData(msg.timeframe, msg.quote);

        this.updateChart(msg.quote.symbol, msg.timeframe);

    },
    onNewChartPrice: function (quote) {


        TradeApp.Util.updateChartOHLC(quote);

        this.updateChart(quote.symbol, "tick");



    },
    /*That is last quote price of the market irrespective of whether the
     * FIX server is on or not. This data is gotten from the history
     * 
     * @param {type} msg
     * @returns {undefined}
     */
    onLastKnownPriceQuotes: function (msg) {
        for (var m in msg) {

            var grid = this.lookupReference('quote_grid_ref');

            var result = null;

            if (grid.isVisible()) {//isVisible not working as excepted - come back for better approach
                result = TradeApp.Util.updateGridWhere(function (record) {
                    record.set('price', m.price);
                }, grid, 'symbol', m.symbol);

            }

        }
    },
    onPriceQuote: function (msg) {

        var me = this;
        this.onNewChartPrice(msg);

        var lblcurrent_symbol = this.lookupReference('chart_symbol');
        if (lblcurrent_symbol && msg.symbol === lblcurrent_symbol.getValue()) {
            //this is the symbol on the chart so we will update the grid
            //price for harmony sake!
            this.updatePriceOnMarketWatch(msg);
            this.updatePriceOnOpenTrades(msg);//COMMENT OUT IF PERFORMANCE IS NOT OK HERE            
        } else {
            //here use UpdateManager to update the components optimally
            //to avoid platform hanging by selecting the best update strategy.
            TradeApp.UpdateManager.update(function (msg) {
                me.updatePriceOnMarketWatch(msg);
                me.updatePriceOnOpenTrades(msg);
            }, msg, msg.symbol, msg.price);

        }


        return false;//important! prevent further call - i suppose it is a bug.
    },
    updatePriceOnMarketWatch: function (msg) {
        var grid = this.lookupReference('quote_grid_ref');

        var result = null;

        if (grid.isVisible()) {//isVisible not working as excepted - come back for better approach
            result = TradeApp.Util.updateGridWhere(function (record) {
                record.set('price', msg.price);
            }, grid, 'symbol', msg.symbol);

        }

        if (!result) {
            TradeApp.Util.refreshGrid(grid, true); // COME BACK TO VERIFY IF WORKING CORRECTLY
        }
    },
    updatePriceOnOpenTrades: function (msg) {

        var result = null;

        grid = this.lookupReference('trade_spotfx_positions');

        if (grid.isVisible()) {//isVisible not working as excepted - come back for better approach
            result = TradeApp.Util.updateGridWhereAll(function (record) {
                record.set('close', msg.price);
            }, grid, 'symbol', msg.symbol);
        }


        grid = this.lookupReference('trade_options_positions');

        if (grid.isVisible()) {//isVisible not working as excepted - come back for better approach
            result = TradeApp.Util.updateGridWhereAll(function (record) {
                record.set('close', msg.price);
            }, grid, 'symbol', msg.symbol);
        }

        return false;//important! prevent further call - i suppose it is a bug.
    },
    displayTotalSpotFxPosition: function (store) {
        var pos_label = this.lookupReference('spotfx_total_open_positions');
        if (pos_label) {
            pos_label.setValue(store.getTotalCount());
        }

    },
    displayTotalOptionsPosition: function (store) {
        var pos_label = this.lookupReference('options_total_open_positions');
        if (pos_label) {
            pos_label.setValue(store.getTotalCount());
        }
    },
    refreshMarketWatch: function () {
        var grid = this.lookupReference('quote_grid_ref');
        TradeApp.Util.refreshGrid(grid, true);
    },
    onOptionsCountdownStart: function (msg) {

        var grid = this.lookupReference('trade_options_positions');
        TradeApp.Util.doTradeGridCountdown(grid, msg.order_ticket, msg.countdown);

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onSpotfxCountdownStart: function (msg) {

        var grid = this.lookupReference('trade_spotfx_positions');
        TradeApp.Util.doTradeGridCountdown(grid, msg.order_ticket, msg.countdown);

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onOptionsCountdownOver: function (msg) {

        var grid = this.lookupReference('trade_options_positions');

        TradeApp.Util.updateGridWhere(function (record) {
            record.set('expiry', msg.expiry);
            record.set('open', msg.open);
            record.set('barrier', msg.barrier);
            record.set('barrier_up', msg.barrier_up);
            record.set('barrier_down', msg.barrier_down);
            record.set('strike', msg.strike);
            record.set('strike_up', msg.strike_up);
            record.set('strike_down', msg.strike_down);
            record.set('premium_paid', msg.premium_paid);
            record.set('close', msg.close);
            record.set('time', msg.time);
        }, grid, 'order', msg.order_ticket);

        //set account balance
        var strFormat = "0,000.00";
        var currency = "$";
        this.lookupReference('trade_tab_panel')
                .setTitle("Account balance: " + currency + Ext.util.Format.number(msg.account_balance, strFormat));

        this.displayTotalOptionsPosition(grid.getStore());

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onSpotfxCountdownOver: function (msg) {

        //console.log(msg);

        var grid = this.lookupReference('trade_spotfx_positions');

        var exchange_id = TradeApp.Util.getUserExchangeId();

        TradeApp.Util.updateGridWhere(function (record) {
            record.set('open', msg.open);
            record.set('stop_loss', exchange_id === msg.seller_id ? msg.seller_stop_loss : msg.buyer_stop_loss);
            record.set('take_profit', exchange_id === msg.seller_id ? msg.seller_take_profit : msg.buyer_take_profit);
            record.set('close', msg.close);
            record.set('time', msg.time);
        }, grid, 'order', msg.order_ticket);

        //set account balance
        if (msg.account_balance) {
            var strFormat = "0,000.00";
            var currency = "$";
            this.lookupReference('trade_tab_panel')
                    .setTitle("Account balance: " + currency + Ext.util.Format.number(msg.account_balance, strFormat));
        }

        this.displayTotalSpotFxPosition(grid.getStore());

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onOptionsPendingOrderCreated: function (msg) {

        var grid = this.lookupReference('pending_options_positions');


        var exchange_id = TradeApp.Util.getUserExchangeId();
        msg.type = exchange_id === msg.seller_id ? "SELLER" : "BUYER";

        var store = grid.getStore();
        //store.add(msg);
        store.insert(0, msg);
        grid.getView().refresh();
        return false;//important! prevent further call - i suppose it is a bug.
    },
    onSpotfxPendingOrderCreated: function (msg) {

        var grid = this.lookupReference('pending_spotfx_positions');

        var exchange_id = TradeApp.Util.getUserExchangeId();
        msg.stop_loss = exchange_id === msg.seller_id ? msg.seller_stop_loss : msg.buyer_stop_loss;
        msg.take_profit = exchange_id === msg.seller_id ? msg.seller_take_profit : msg.buyer_take_profit;

        msg.type = exchange_id === msg.seller_id ? "SELLER" : "BUYER";

        var store = grid.getStore();
        //store.add(msg);
        store.insert(0, msg);
        grid.getView().refresh();

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onSpotfxPendingOrderDeleted: function (msg) {

        console.log('onSpotfxPendingOrderDeleted');

        var p_grid = this.lookupReference('pending_spotfx_positions');
        TradeApp.Util.deleteGridWhere(p_grid, 'order', msg.order_ticket);


        var op_grid = this.lookupReference('trade_spotfx_positions');
        TradeApp.Util.refreshGrid(op_grid, true);
    },
    onOptionsPendingOrderDeleted: function (msg) {

        console.log('onOptionsPendingOrderDeleted');

        var p_grid = this.lookupReference('pending_options_positions');
        TradeApp.Util.deleteGridWhere(p_grid, 'order', msg.order_ticket);

        var op_grid = this.lookupReference('trade_options_positions');
        TradeApp.Util.refreshGrid(op_grid, true);
    },
    onOptionsTradeClosed: function (msg) {

        var op_grid = this.lookupReference('trade_options_positions');
        TradeApp.Util.deleteGridWhere(op_grid, 'order', msg.order_ticket);

        var hs_grid = this.lookupReference('trade_history_options');
        var store = hs_grid.getStore();
        //store.add(msg);
        store.insert(0, msg);
        hs_grid.getView().refresh();

        //set account balance
        var strFormat = "0,000.00";
        var currency = "$";
        this.lookupReference('trade_tab_panel')
                .setTitle("Account balance: " + currency + Ext.util.Format.number(msg.account_balance, strFormat));

        this.displayTotalOptionsPosition(op_grid.getStore());

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onSpotfxTradeClosed: function (msg) {

        console.log('onSpotfxTradeClosed');

        var op_grid = this.lookupReference('trade_spotfx_positions');
        TradeApp.Util.deleteGridWhere(op_grid, 'order', msg.order_ticket);

        var hs_grid = this.lookupReference('trade_history_spotfx');
        var store = hs_grid.getStore();
        //store.add(msg);
        store.insert(0, msg);
        hs_grid.getView().refresh();

        //set account balance
        var strFormat = "0,000.00";
        var currency = "$";
        this.lookupReference('trade_tab_panel')
                .setTitle("Account balance: " + currency + Ext.util.Format.number(msg.account_balance, strFormat));

        this.displayTotalSpotFxPosition(op_grid.getStore());

        return false;//important! prevent further call - i suppose it is a bug.
    },
    onAccountInfo: function (info) {
        console.log(info);
        var strFormat = "0,000.00";
        var currency = "$";
        var indsp = this.lookupReference('trade_tab_panel');
        if (indsp)
        {
            indsp.setTitle("Account balance: " + currency + Ext.util.Format.number(info.account_balance, strFormat));
        }
        /*
         var indsp = this.lookupReference('spotfx_initial_deposit');
         if(indsp)
         {
         indsp.setValue(currency + Ext.util.Format.number(info.initial_deposit, strFormat));
         }
         
         var indo = this.lookupReference('options_initial_deposit');
         if(indo)
         {
         indo.setValue(currency + Ext.util.Format.number(info.initial_deposit, strFormat));
         
         }
         */
        return false;//important! prevent further call - i suppose it is a bug.
    },
    onAccountModified: function (info) {
        var me = this;
        Ext.Ajax.request({
            url: 'access_247/account_info',
            method: 'POST',
            params: "access_token=" + TradeApp.Util.getAccessToken()
                    + "&version=" + TradeApp.Util.version,
            success: function (conn, response, options, eOpts) {
                try {
                    TradeApp.Util.refreshGrid("deposits-and-withdrawals-id", true);
                    var data = JSON.parse(conn.responseText);
                    me.onAccountInfo(data);

                } catch (e) {
                    console.log(e); // uncomment in production
                }

            },
            failure: function (conn, response, options, eOpts) {
                //not interested
            }
        });

    },
    onShowLiveTrades: function () {
        var trade_positions = this.lookupReference('trade_positions');
        var trade_history = this.lookupReference('trade_history');

        trade_history.hide();
        trade_positions.show();

    },
    onShowAccountHistory: function () {

        var trade_positions = this.lookupReference('trade_positions');
        var trade_history = this.lookupReference('trade_history');

        trade_positions.hide();
        trade_history.show();
    },
    onChartPan: function () {
        _highcharts.update({chart: {panning: true}});//enable panning
        _highcharts.update({chart: {zoomType: ''}});//disable zoom
    },
    onChartZoom: function () {
        _highcharts.update({chart: {zoomType: 'xy'}});//enable zoom
        _highcharts.update({chart: {panning: false}});//disable panning
    },
    checkOnly: function (all, menu) {
        menu.checked = true;
        menu.addCls('x-form-cb-checked x-form-dirty');
        for (var i in all) {
            if (all[i] !== menu) {
                all[i].checked = false;
                all[i].removeCls('x-form-cb-checked x-form-dirty');
                //all[i].checkChange();
            }
        }

    },
    allowRedraw: function (name) {
        /*
         var line = this.lookupReference('menu_line_chart'),
         area = this.lookupReference('menu_area_chart'),
         candle = this.lookupReference('menu_candle_stick_chart'),
         ohlc = this.lookupReference('menu_ohlc_chart');
         
         var all = [line, area, candle, ohlc];
         switch (name) {
         case 'line':
         this.checkOnly(all, line);
         return line.checked;
         case 'area':
         this.checkOnly(all, area);
         return area.checked;
         break;
         case 'candle_stick':
         this.checkOnly(all, candle);
         return candle.checked;
         case 'ohlc':
         this.checkOnly(all, ohlc);
         return ohlc.checked;
         }
         */

    },
    redrawChart: function (type, name) {
        //EMPTY
    },
    changeChart: function (type) {
        this._chartType = type;

        _highchartSeries.update({type: this._chartType});

        if (!this._chartSymbol || !this._chartTimeframe) {
            return;
        }
        var symbol = this._chartSymbol;
        var tf = this._chartTimeframe;

        this.onChartTimeframe();
    },
    onLineChart: function () {
        this.changeChart('line');
    },
    onAreaChart: function () {
        this.changeChart('area');
    },
    onCandleStickChart: function () {
        this.changeChart('candlestick');
    },
    onOhlcChart: function () {
        this.changeChart('ohlc');
    },
    resetChart: function (chart) {
        //EMPTY
    },
    onChartReset: function () {

        _highcharts.update({chart: {zoomType: ''}});//disable zoom
        _highcharts.update({chart: {panning: false}});//disable panning

        _highcharts.zoom();//IMPORTANT! restore chart

    },
    onThemeSwitch: function () {
        //EMPTY
    },
    checkChart: function (chart) {
        //EMPTY
    },
    ensureInitHighChartData: function (symbol, tf) {
        if (!this._highChartData[symbol]) {
            this._highChartData[symbol] = {};
        }

        if (!this._highChartData[symbol][tf]) {
            this._highChartData[symbol][tf] = [];
        }

    },
    updateHighChartOptions: function (quote, symbol, tf) {
        var o = TradeApp.Util.chartTFS(tf);
        if (!o) {
            return;//do nothing - though unlikely at this piont anyway!
        }

        //quote.tf_time = quote.time - (quote.time % 60000);//testing

        var ms = o.secs * 1000;
        var bar_to_show = TradeApp.Util.numBars();
        var right_padding = 5;
        var Xmax = quote.tf_time + ms * right_padding;
        var Xmin = Xmax - ms * bar_to_show;


        var limit = TradeApp.Util.getPriceMinMax(symbol, tf);
        var y_space = this.getPricePipsSpace(symbol, 10);
        if (limit) {
            var Ymin = limit.min - y_space;
            var Ymax = limit.max + y_space;
            _highcharts.yAxis[0].update({max: Ymax, min: Ymin}, false);
        }

        var digits = this.getSymbolDigitCount(symbol);
        _highcharts.update({tooltip: {valueDecimals: digits}}, false);

        _highcharts.yAxis[0].update({tickInterval: y_space}, false);

        _highcharts.xAxis[0].update({max: Xmax, min: Xmin, tickInterval: ms * 5}, false);



    },
    updateChart: function (symbol, timeframe) {


        var cbo_tf = this.lookupReference('timeframe');
        if (!cbo_tf) {//for a reason i do not understand the ExtJS build produce reference error. i dont know why!
            return;
        }
        var tf = TradeApp.Util.toTF(cbo_tf.value);

        var quote = TradeApp.Util.getLastChartTFPrice(symbol, tf);
        if (!quote) {//is possible
            return;
        }

        if (this._chartSymbol !== symbol || this._chartTimeframe !== tf) {
            return;
        }

        this._chartSymbol = symbol;
        this._chartTimeframe = tf;
        //console.log(quote);

        this.ensureInitHighChartData(symbol, tf);

        var q_data = [
            quote.tf_time,
            quote.open,
            quote.high,
            quote.low,
            quote.close
        ];


        this.updateHighChartOptions(quote, symbol, tf);

        var p = this._highChartData[symbol][tf];

        var last_data = p[p.length - 1];
        var last_time;
        if (last_data) {
            last_time = last_data[0];
        }

        if (!last_data
                || _highchartSeries.data.length !== p.length
                || (last_time && last_time < quote.tf_time)) {//if new candle stick

            this._highChartData[symbol][tf].push(q_data);
            this.setHighchartsData(this._highChartData[symbol][tf], true, true);//animate - true
        } else {
            //update the last data
            p[p.length - 1] = q_data;
            this.updateLastHighchartsData(this._highChartData[symbol][tf], true, false);//do not animate - false
        }


    },

    showHighchartsPriceLine: function (close) {
        if (this._chartSymbol) {
            var decimal_places = this.getSymbolDigitCount(this._chartSymbol);
            close = close.toFixed(decimal_places);
        }
        //remove old price line
        _highcharts.yAxis[0].removePlotLine('price_line_id');

        var color = 'black';
        var text = '<div style="width: 50px; height: 16px; margin-right: -40px;'
                + ' margin-top: 7px; font-size: 11px; background-color: ' + color + '; color: white;">'
                + close
                + '</div>';

        //add current price line
        _highcharts.yAxis[0].addPlotLine({
            id: 'price_line_id',
            color: color,
            width: 0.3,
            value: close,
            label: {
                text: text,
                align: 'right',
                useHTML: true

            }
        });
    },

    isGoldOrSilver: function (symbol) {
        return symbol === "XAUUSD"
                || symbol === "XAU/USD"
                || symbol === "XAGUSD"
                || symbol === "XAG/USD";
    },
    getPricePipsSpace: function (symbol, space) {
        var len = symbol.length;
        var sIndex = 0;//e.g JPY/AUD - where JPY is the base currency
        var eIndex = len - 3;//e.g USD/JPY, USDJPY - where JPY is not the base currency
        var indexOfJPY = symbol.indexOf("JPY");
        var pips = space || 10;
        var step = 0.0001 * pips;
        if (indexOfJPY === sIndex || indexOfJPY === eIndex || this.isGoldOrSilver(symbol)) {
            step = 0.01 * pips;
        }
        return step;
    },

    getSymbolDigitCount: function (symbol) {
        var len = symbol.length;
        var sIndex = 0;//e.g JPY/AUD - where JPY is the base currency
        var eIndex = len - 3;//e.g USD/JPY, USDJPY - where JPY is not the base currency
        var indexOfJPY = symbol.indexOf("JPY");
        if (indexOfJPY === sIndex || indexOfJPY === eIndex || this.isGoldOrSilver(symbol)) {
            return 3;
        }
        return 5;
    },

    onChartTimeframe: function (symbol) {
        var symbolCmp = this.lookupReference('chart_symbol');
        var symb = symbolCmp.getValue();
        if (typeof symbol === "string") {
            symbolCmp.setValue(symbol);
        } else {
            symbol = symb;
        }

        if (!symbol) {
            return;
        }

        var cbo_tf = this.lookupReference('timeframe');
        var tf = TradeApp.Util.toTF(cbo_tf.value);
        if (!cbo_tf) {//for a reason i do not understand the ExtJS build produce reference error. i dont know why!
            return;
        }

        this._chartSymbol = symbol;
        this._chartTimeframe = tf;

        var tf_data = TradeApp.Util.chartTFData(symbol, tf);

        var me = this;
        var MIN_BARS = 15;//if less than this minimum then request timeframe data
        me.afterChartData(tf_data, symbol, tf);
        if (!tf_data || (tf_data && tf_data.length < MIN_BARS)) {
            TradeApp.Util.requestHighchartsTimeframeData(symbol, cbo_tf, cbo_tf.value, function (data) {
                me.afterChartData(data, symbol, tf);
            });
        }


    },
    afterChartData: function (tf_data, symbol, tf) {
        if (!tf_data || tf_data.length === 0) {
            return;
        }
        this.ensureInitHighChartData(symbol, tf);

        this._highChartData[symbol][tf] = [];//clear previous - we want to put afresh

        var last_quote = tf_data[tf_data.length - 1];
        this.updateHighChartOptions(last_quote, symbol, tf);

        var hqoutes = TradeApp.Util.toHighchartsTFData(tf_data);
        this._highChartData[symbol][tf] = hqoutes;

        this.setHighchartsData(this._highChartData[symbol][tf], true, true);//animate - true

    },

    setHighchartsData: function (tf_data, force_update, animate) {
        var last_data = tf_data[tf_data.length - 1];
        var last_close_price = last_data[last_data.length - 1];
        var d;
        if (this._chartType === 'line' || this._chartType === 'area') {
            var ln_tf_data = [];
            for (var i = 0; i < tf_data.length; i++) {
                ln_tf_data.push([
                    tf_data[i][0], //time
                    tf_data[i][4] //close price
                ]);
            }
            d = ln_tf_data;
        } else if (this._chartType === 'ohlc' || this._chartType === 'candlestick') {
            d = tf_data;
        }

        _highchartSeries.setData(d, force_update, animate);

        this.showHighchartsPriceLine(last_close_price);
    },

    updateLastHighchartsData: function (tf_data, force_update, animate) {
        var series_last_data = _highchartSeries.data[_highchartSeries.data.length - 1];
        var last_data = tf_data[tf_data.length - 1];
        var last_close_price = last_data[last_data.length - 1];

        var d;
        if (this._chartType === 'line' || this._chartType === 'area') {
            var ln_last_data = [
                last_data[0], //time
                last_data[4] //close price
            ];
            d = ln_last_data;
        } else if (this._chartType === 'ohlc' || this._chartType === 'candlestick') {
            d = last_data;
        }

        series_last_data.update(d, force_update, animate);

        this.showHighchartsPriceLine(last_close_price);

    },
    afterChartLoad: function (chart, symbol, tf) {
        //EMTPY
    },
    onChartRendered: function () {
        //EMPTY
    },
    onChartDestroy: function () {
        alert('onChartDestroy - Ends price move simulation');
        if (this.priceMoveSimulationTask) {
            Ext.TaskManager.stop(this.priceMoveSimulationTask);
        }
    },
    onWithdrawClick: function () {
        Ext.create('TradeApp.view.main.WithdrawalDialog', TradeApp.Util.onHideThenDestroy).show();
    },
    onLoginClick: function () {
        if (TradeApp.Util.isLogin()) {
            TradeApp.Util.logout();
        } else {
            TradeApp.Util.login();
        }
    },
    checkUserSessionExist: function () {

        if (TradeApp.Util.isLogin()) {
            TradeApp.Util.afterLogin();
        }
    },
    onMainTabsChange: function (tabPanel, newC, oldC) {
        if (newC.id === "exchange-room-tab") {
            Ext.GlobalEvents.fireEvent('check_exchange_update');
        }
    }

});
