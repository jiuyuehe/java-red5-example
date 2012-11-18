package jp.nak2k.red5.example;

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IConnection;
import org.red5.server.api.IContext;
import org.red5.server.api.scheduling.IScheduledJob;
import org.red5.server.api.scheduling.ISchedulingService;
import org.red5.server.api.service.ServiceUtils;

/**
 * 
 * @author Kengo Nakatsuka
 * 
 */
public class Application extends ApplicationAdapter {
	/**
	 * 
	 */
	public Application() {
	}

	/**
	 * @param conn
	 */
	public void test(IConnection conn) {
		IContext context = conn.getScope().getContext();
		ISchedulingService schedulingService = (ISchedulingService) context
				.getBean(ISchedulingService.BEAN_NAME);

		final IConnection finalizedConn = conn;
		schedulingService.addScheduledOnceJob(10 * 1000, new IScheduledJob() {
			@Override
			public void execute(ISchedulingService service)
					throws CloneNotSupportedException {
				ServiceUtils.invokeOnConnection(finalizedConn,
						"onTestCallback", new Object[] {});
			}
		});
	}
}
