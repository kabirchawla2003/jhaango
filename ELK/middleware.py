import logging
import time
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger('django')

class RequestLoggingMiddleware(MiddlewareMixin):
    def process_request(self, request):
        request.start_time = time.time()

    def process_response(self, request, response):
        if hasattr(request, 'start_time'):
            duration = time.time() - request.start_time
            logger.info(
                f"""
                Path: {request.path}
                Method: {request.method}
                Status: {response.status_code}
                Duration: {duration:.2f}s
                User: {request.user}
                """
            )
        return response
