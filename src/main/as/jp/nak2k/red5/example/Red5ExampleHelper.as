package jp.nak2k.red5.example
{
  import flash.events.MouseEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.StatusEvent;
  import flash.media.Microphone;
  import flash.media.MicrophoneEnhancedMode;
  import flash.media.MicrophoneEnhancedOptions;
  import flash.media.SoundCodec;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.net.Responder;
  import mx.core.IMXMLObject;
  import mx.events.FlexEvent;

  public class Red5ExampleHelper implements IMXMLObject {
    private var view:Red5Example;
    private var netConnection:NetConnection;

    [Bindable] internal var connectUrl:String;

    /**
     * mxml 読み込み時に呼び出されます。
     */
    public function initialized(document:Object, id:String):void {
      /*
       * Initialize view.
       */
      view = document as Red5Example;

      view.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

      /*
       *
       */
      netConnection = new NetConnection();
      netConnection.client = {
        onBWDone: function () : void {
          log("netConnectin.client.onBWDone called.");
        },
        onTestCallback: function () : void {
          log("netConnectin.client.onTestCallback called.");
        }
      };

      netConnection.addEventListener(NetStatusEvent.NET_STATUS, function (_evt:NetStatusEvent) : void {
        log("NetConnection: " + _evt.info.code);
        switch (_evt.info.code) {
        case "NetConnection.Connect.Success":
          break;
        case "NetConnection.Connect.NetworkChange":
          break;
        case "NetConnection.Connect.Closed":
          break;
        }
      });

      netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function securityErrorHandler(_evt:SecurityErrorEvent) : void {
        log("SecurityError: " + _evt);
      });
    }

    /**
     * View の作成完了時に呼び出されます。
     * 各コンポーネントへイベントハンドラを設定し、Bindable なプロパティを初期化します。
     */
    private function onCreationComplete(event:FlexEvent):void {
      view.connectButton.addEventListener(MouseEvent.CLICK, onConnectButtonClick);
      view.testButton.addEventListener(MouseEvent.CLICK, onTestButtonClick);
      view.measureBandwidthButton.addEventListener(MouseEvent.CLICK, onMeasureBandwidthButtonClick);

      connectUrl  = "rtmp://localhost/red5-example/rooms/room1";
    }

    /**
     *
     */
    private function onConnectButtonClick(event:MouseEvent):void {
      log("onConnectButtonClick");

      netConnection.connect(connectUrl);
    }

    private function onTestButtonClick(event:MouseEvent):void {
      log("onTestButtonClick");
      netConnection.call("test", null);
    }

    private function onMeasureBandwidthButtonClick(event:MouseEvent):void {
      log("onMeasureBandwidthButtonClick");
      netConnection.call("measureBandwidth", null);
    }

    /**
     *
     */
    private function log(msg:String) : void {
      view.logTextArea.appendText(msg);
      view.logTextArea.appendText("\n");
    }
  }
}
