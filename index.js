import express from "express";
import fs from "fs";
import path from "path";
import Handlebars from "handlebars";
import cors from "cors";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import pdf from "html-pdf-node";

// Recreate __dirname in ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config();

const app = express();
const port = process.env.PORT;

// Enable JSON body parsing
app.use(express.json());

// CORS setup
const allowedOrigin =
  process.env.NODE_ENV === "production" ? process.env.CLIENT_ORIGIN : "*";
app.use(cors({ origin: allowedOrigin, methods: ["GET", "POST", "OPTIONS"] }));

// Load and compile the Handlebars template
const templatePath = path.join(__dirname, "invoice-template.html");
const templateHtml = fs.readFileSync(templatePath, "utf8");
const template = Handlebars.compile(templateHtml);

// PDF generation endpoint
app.post("/generate-pdf", async (req, res) => {
  try {
    const invoiceData = req.body;
    const finalHtml = template(invoiceData);

    const file = { content: finalHtml };

    // Set Puppeteer executable path from env (used internally by html-pdf-node)
    // Set Puppeteer executable path only in production
    if (process.env.NODE_ENV === "production") {
      process.env.PUPPETEER_EXECUTABLE_PATH =
        process.env.PUPPETEER_EXECUTABLE_PATH || "/usr/bin/chromium";
    }

    const pdfBuffer = await pdf.generatePdf(file, {
      format: "A4",
      printBackground: true,
      margin: {
        top: "20px",
        bottom: "20px",
        left: "20px",
        right: "20px",
      },
    });

    res.set("Content-Type", "application/pdf");
    res.set("Content-Disposition", "attachment; filename=invoice.pdf");
    res.send(pdfBuffer);
  } catch (error) {
    console.error("PDF generation error:", error);
    res
      .status(500)
      .json({ message: "Error generating PDF", error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
