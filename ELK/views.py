from django.shortcuts import render
import logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

logger = logging.getLogger('django')

class ProtectedView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        logger.info(f"Protected view accessed by user: {request.user.username}")
        return Response({
            "message": "You have access to this protected view",
            "user": request.user.username
        })

# Create your views here.
