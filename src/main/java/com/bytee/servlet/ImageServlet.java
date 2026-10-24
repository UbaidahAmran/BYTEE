package com.bytee.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "C:/bytee_uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Get the filename from the URL (e.g., ImageServlet?file=123.jpg)
        String fileName = request.getParameter("file");
        
        if (fileName == null || fileName.equals("")) return;
        
        // Strip any directory parts to prevent path traversal (e.g. ../../)
        fileName = new File(fileName).getName();
        File file = new File(UPLOAD_DIR + File.separator + fileName);
        
        if (file.exists()) {
            // Tell browser this is an image
            String mimeType = getServletContext().getMimeType(file.getAbsolutePath());
            if (mimeType == null) mimeType = "application/octet-stream";
            response.setContentType(mimeType);
            
            // Write image to output
            FileInputStream in = new FileInputStream(file);
            OutputStream out = response.getOutputStream();
            
            byte[] buffer = new byte[4096];
            int length;
            while ((length = in.read(buffer)) > 0){
                out.write(buffer, 0, length);
            }
            in.close();
            out.close();
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
        }
    }
}