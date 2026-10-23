import os
import sys
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#64748B"))
        
        # Header (pages > 1)
        if self._pageNumber > 1:
            self.drawString(40, 760, "AgriYard Flutter Project - Presentation & Code Reference Guide")
            self.setStrokeColor(colors.HexColor("#CBD5E1"))
            self.setLineWidth(0.5)
            self.line(40, 752, 572, 752)
        
        # Footer
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(572, 30, page_text)
        self.drawString(40, 30, "College Viva & Practical Presentation Guide")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.5)
        self.line(40, 42, 572, 42)
        
        self.restoreState()

def build_pdf(filename="AgriYard_Presentation_Guide.pdf"):
    doc = SimpleDocTemplate(
        filename,
        pagesize=letter,
        leftMargin=40,
        rightMargin=40,
        topMargin=55,
        bottomMargin=55
    )

    styles = getSampleStyleSheet()
    
    # Custom styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        textColor=colors.HexColor("#137547"),
        spaceAfter=6
    )
    
    subtitle_style = ParagraphStyle(
        'DocSub',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=colors.HexColor("#475569"),
        spaceAfter=15
    )

    h1_style = ParagraphStyle(
        'H1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=16,
        leading=20,
        textColor=colors.HexColor("#137547"),
        spaceBefore=12,
        spaceAfter=8
    )

    h2_style = ParagraphStyle(
        'H2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=colors.HexColor("#0F172A"),
        spaceBefore=8,
        spaceAfter=4
    )

    body_style = ParagraphStyle(
        'Body',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=colors.HexColor("#1E293B")
    )

    bold_body = ParagraphStyle(
        'BoldBody',
        parent=body_style,
        fontName='Helvetica-Bold',
        textColor=colors.HexColor("#0F172A")
    )

    code_style = ParagraphStyle(
        'CodeStyle',
        parent=styles['Normal'],
        fontName='Courier-Bold',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#0D5332")
    )

    tip_box_style = ParagraphStyle(
        'TipStyle',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#166534")
    )

    story = []

    # Title & Header
    story.append(Paragraph("AgriYard - Flutter Project Presentation Guide", title_style))
    story.append(Paragraph("Complete Widget Architecture, Purpose & Code File Mapping for College Viva", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=2, color=colors.HexColor("#137547"), spaceAfter=15))

    # Viva Tips Box
    tip_data = [[
        Paragraph(
            "<b>Key Presentation Tip for College Professor:</b><br/>"
            "Explain that the entire project follows Flutter's <b>Declarative Widget Tree Architecture</b>. "
            "Every screen starts with a <code>Scaffold</code>, structured vertically with <code>Column</code> or scrollable lists (<code>ListView.builder</code> / <code>GridView.builder</code>), "
            "and styled with reusable custom components (<code>CustomPrimaryButton</code>, <code>CustomInputField</code>, <code>AppCurvedHeader</code>).",
            tip_box_style
        )
    ]]
    tip_table = Table(tip_data, colWidths=[532])
    tip_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F0FDF4")),
        ('BORDER', (0,0), (-1,-1), 1, colors.HexColor("#86EFAC")),
        ('PADDING', (0,0), (-1,-1), 8),
        ('ROUNDEDCORNERS', [4, 4, 4, 4]),
    ]))
    story.append(tip_table)
    story.append(Spacer(1, 15))

    # SECTION 1: WIDGET DIRECTORY & EXPLANATION
    story.append(Paragraph("Part 1: Flutter Widgets Dictionary (Meaning & Exact Purpose)", h1_style))
    story.append(Paragraph("When the professor asks: <i>'What is this widget and why did you use it?'</i>, refer to the answers below:", body_style))
    story.append(Spacer(1, 8))

    widgets_data = [
        [Paragraph("<b>Widget Name</b>", bold_body), Paragraph("<b>What it is (Role)</b>", bold_body), Paragraph("<b>Exact Purpose in AgriYard App</b>", bold_body)],
        
        [Paragraph("<b>Scaffold</b>", bold_body),
         Paragraph("Base layout structure of a screen", body_style),
         Paragraph("Provides background color, AppBar slot, Body area, and BottomNavigationBar slot.", body_style)],
        
        [Paragraph("<b>SafeArea</b>", bold_body),
         Paragraph("Invasive UI padding shield", body_style),
         Paragraph("Prevents content from getting clipped by mobile camera notches and top status bars.", body_style)],

        [Paragraph("<b>Column</b>", bold_body),
         Paragraph("Vertical layout container", body_style),
         Paragraph("Arranges child widgets in a vertical line (top-to-bottom), like Logo above input fields.", body_style)],

        [Paragraph("<b>Row</b>", bold_body),
         Paragraph("Horizontal layout container", body_style),
         Paragraph("Arranges child widgets side-by-side, e.g., Search bar next to Date Picker, or Min/Max prices.", body_style)],

        [Paragraph("<b>SingleChildScrollView</b>", bold_body),
         Paragraph("Scrollable single-child wrapper", body_style),
         Paragraph("Allows scrolling when screen content overflows or when mobile keyboard opens.", body_style)],

        [Paragraph("<b>ListView.builder</b>", bold_body),
         Paragraph("Dynamic lazy-loading list", body_style),
         Paragraph("Efficiently renders large lists (Crop Rates, Shops, Users) only loading visible items.", body_style)],

        [Paragraph("<b>GridView.builder</b>", bold_body),
         Paragraph("2D grid layout generator", body_style),
         Paragraph("Creates the 2x2 grid cards of Marketing Yards (Rajkot, Junagadh, Gondal, Mendarda) on Home.", body_style)],

        [Paragraph("<b>Container</b>", bold_body),
         Paragraph("Universal box styling model", body_style),
         Paragraph("Sets custom width, height, padding, borders, background colors, and BoxShadows.", body_style)],

        [Paragraph("<b>Expanded</b>", bold_body),
         Paragraph("Flex space consumer", body_style),
         Paragraph("Expands a child of Row/Column to fill all remaining available space evenly.", body_style)],

        [Paragraph("<b>Stack / Positioned</b>", bold_body),
         Paragraph("Overlapping layer system", body_style),
         Paragraph("Used on Onboarding (Farmer & Tractor placed on green hill) and Home cards (gradient over images).", body_style)],

        [Paragraph("<b>Card</b>", bold_body),
         Paragraph("Material surface container", body_style),
         Paragraph("Displays distinct content sections with rounded corners and elevation/shadow.", body_style)],

        [Paragraph("<b>TextField / TextFormField</b>", bold_body),
         Paragraph("User text input field", body_style),
         Paragraph("Accepts inputs with validation in Login, Signup, Forgot Password, and Shop Search.", body_style)],

        [Paragraph("<b>ElevatedButton</b>", bold_body),
         Paragraph("Primary raised action button", body_style),
         Paragraph("Main solid action buttons (Login, Create Account, Apply Filters, Send Reset Link).", body_style)],

        [Paragraph("<b>OutlinedButton</b>", bold_body),
         Paragraph("Bordered secondary button", body_style),
         Paragraph("Used for secondary actions like Logout button and secondary screen options.", body_style)],

        [Paragraph("<b>TextButton</b>", bold_body),
         Paragraph("Border-free clickable text", body_style),
         Paragraph("Used for text-only links like 'Forgot Password?' and 'Sign Up' prompts.", body_style)],

        [Paragraph("<b>ListTile</b>", bold_body),
         Paragraph("Standardized list item row", body_style),
         Paragraph("Displays leading icon, title, subtitle, and trailing arrow in Profile and Settings menus.", body_style)],

        [Paragraph("<b>DataTable / PriceTable</b>", bold_body),
         Paragraph("Tabular multi-column grid", body_style),
         Paragraph("Renders 7-day historical prices (Date, Min, Avg, Max) on Crop Detail screens.", body_style)],

        [Paragraph("<b>CircularProgressIndicator</b>", bold_body),
         Paragraph("Activity spinner loader", body_style),
         Paragraph("Shows animated spinning circle on Splash Screen while app prepares data.", body_style)],
    ]

    w_table = Table(widgets_data, colWidths=[110, 160, 262])
    w_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#E2E8F0")),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(w_table)
    story.append(Spacer(1, 15))

    # SECTION 2: SCREEN BY SCREEN BREAKDOWN & CODE FILE MAPPING
    story.append(PageBreak())
    story.append(Paragraph("Part 2: Screen-by-Screen Code File Mapping", h1_style))
    story.append(Paragraph("Exact file paths, widgets used, and location references for all screens:", body_style))
    story.append(Spacer(1, 10))

    screens_data = [
        # 1. Splash
        ("1. Splash / Loading Screen",
         "lib/screens/auth/splash_screen.dart",
         "Scaffold, Column, FadeTransition, ScaleTransition, Image.asset, CircularProgressIndicator",
         "Initial launch screen with animated AgriYard logo, tagline, and loading spinner."),

        # 2. Onboarding
        ("2. Welcome / Onboarding Screen",
         "lib/screens/auth/onboarding_screen.dart",
         "Scaffold, SafeArea, SingleChildScrollView, Stack, Container, Image.asset, CustomPrimaryButton",
         "Welcomes user with farmer/tractor illustration, 3 core feature highlights, and 'Get Started' action."),

        # 3. Login
        ("3. Login Screen",
         "lib/screens/auth/login_screen.dart",
         "Scaffold, Form, Column, CustomInputField, TextButton (Forgot Password), CustomPrimaryButton",
         "User authentication screen with email & password validation and navigation to Signup & Forgot Password."),

        # 4. Forgot Password
        ("4. Forgot Password Screen",
         "lib/screens/auth/forgot_password_screen.dart",
         "Scaffold, AppBar, Container (Lock icon), CustomInputField, CustomPrimaryButton",
         "Allows users to enter their email/mobile to receive password reset link."),

        # 5. Signup
        ("5. Register / Create Account Screen",
         "lib/screens/auth/signup_screen.dart",
         "Scaffold, Form, SingleChildScrollView, 5x CustomInputField, CustomPrimaryButton",
         "Account registration with fields for Full Name, Mobile, Email, Password, and Confirm Password."),

        # 6. Home Screen
        ("6. Main Dashboard / Home Screen",
         "lib/screens/home/home_screen.dart",
         "AppCurvedHeader, Row, Search Container, GridView.builder (2x2 Yards), Price Rise & Fall Action Cards",
         "Core dashboard featuring curved green header, quick search, date selector, 2x2 marketing yards grid, and trend cards."),

        # 7. Search Results
        ("7. Search Results Screen",
         "lib/screens/home/search_results_screen.dart",
         "AppBar (with search TextField), ListView.separated, Result Card Container, Image.asset",
         "Live search results displaying matching crops across yards with rates and quick navigation."),

        # 8. Filter & Sort
        ("8. Filter & Sort Screen",
         "lib/screens/home/filter_sort_screen.dart",
         "AppBar, Custom Radio/Circle (Sort), Custom Checkboxes (Yards), CustomPrimaryButton",
         "Allows sorting by price (high/low) and filtering by specific yards (Rajkot, Gondal, Junagadh, Mendarda)."),

        # 9. Yard Detail
        ("9. Marketing Yard Details (Rajkot / Gondal / Mendarda)",
         "lib/screens/yards/yard_detail_screen.dart",
         "AppBar, Image.asset (Yard photo), 4x Info Rows (Address, Phone, Shops, Est.), Row of 2 Action Buttons",
         "Full profile of selected marketing yard with direct buttons to view Today's Rates and Shop List."),

        # 10. Today's Market Rates
        ("10. Today's Market Rates Screen",
         "lib/screens/market/market_rates_screen.dart",
         "AppBar, ListView.separated, Crop Card Container, Row (Arrival, Min, Avg, Max), ElevatedButton",
         "Comprehensive list of all crops with daily arrival volume, minimum, average, and maximum prices."),

        # 11. Crop Detail
        ("11. Crop Detail Screen (Wheat, Soyabean, Chana, Tuver, Garlic)",
         "lib/screens/market/crop_detail_screen.dart",
         "Image Container, Summary Badge (20kg), 2x Metric Rows (Total arrival, Min/Avg/Max), PriceTable",
         "Detailed crop analysis page showing 20kg pricing, arrival stats, price capsule, and 7-day historical rate table."),

        # 12. Price Rise
        ("12. Price Rise / Top Gainers Screen",
         "lib/screens/market/price_rise_screen.dart",
         "AppBar, Header Icon, ListView.separated, Green Gain Badge Container, Price Stats Row",
         "Displays crops with highest upward price momentum today with percentage increase badges."),

        # 13. Shop List
        ("13. Shop List Screen",
         "lib/screens/shops/shop_list_screen.dart",
         "AppBar, TextField (Search), ListView.separated, Shop Card Container, IconButton (Direct Phone Call)",
         "Directory of trusted APMC market yard shops with shop numbers, merchant names, and one-tap calling."),

        # 14. User Profile
        ("14. User Profile Screen",
         "lib/screens/profile/profile_screen.dart",
         "Curved Header, CircleAvatar, Text, ListTile menu (Personal Info, Password, Help, Logout)",
         "User account settings with profile picture, personal details, and links to change password and support."),

        # 15. Change Password
        ("15. Change Password Screen",
         "lib/screens/profile/change_password_screen.dart",
         "AppBar, 3x CustomInputField (Current, New, Confirm), CustomPrimaryButton",
         "Form allowing users to update their login credentials securely."),

        # 16. Admin Dashboard
        ("16. Admin Dashboard Screen",
         "lib/screens/admin/admin_dashboard_screen.dart",
         "AppBar, Stat Cards (Users, Active Yards), DropdownButtonFormField, InputFields (Quick Rate Update)",
         "Admin control center for quick price updates, viewing system metrics, and selecting yards."),

        # 17. Admin Manage Data
        ("17. Admin Manage Data Screen",
         "lib/screens/admin/admin_manage_data_screen.dart",
         "TabBar (Yards, Crops, Shops), ElevatedButton (Add New), ListView.builder, Edit/Delete IconButtons",
         "CRUD management screen for creating, editing, and deleting yards, crops, and shops."),

        # 18. Admin Users & Alerts
        ("18. Admin Users & Alerts Screen",
         "lib/screens/admin/admin_users_alerts_screen.dart",
         "TextField (Push Message), ElevatedButton (Send), ListView.builder, Status Chip (Active/Blocked)",
         "Broadcasting push notifications and managing registered user accounts with active/blocked toggle."),

        # 19. Admin Settings
        ("19. Admin Settings Screen",
         "lib/screens/admin/admin_settings_screen.dart",
         "AppBar, ListTiles (Admin Password, Helpline, Terms, Version), OutlinedButton (Logout)",
         "Administrative configuration screen for system credentials, contact info, and app settings."),

        # 20. Main Navigation
        ("20. Main Navigation Wrapper",
         "lib/screens/main_navigation_screen.dart",
         "Scaffold, IndexedStack (Preserves Tab States), CustomBottomNav (5 Persistent Tabs)",
         "Root navigation shell managing the 5 primary tabs: Home, Market Rates, Price Rise, Shops, Profile.")
    ]

    for title, filepath, widgets_used, desc in screens_data:
        screen_content = [
            Paragraph(f"<b>{title}</b>", h2_style),
            Paragraph(f"<b>File:</b> <code>{filepath}</code>", code_style),
            Spacer(1, 2),
            Paragraph(f"<b>Key Widgets:</b> {widgets_used}", body_style),
            Paragraph(f"<b>Purpose:</b> {desc}", body_style),
            Spacer(1, 4),
            HRFlowable(width="100%", thickness=0.5, color=colors.HexColor("#E2E8F0"), spaceAfter=6)
        ]
        story.append(KeepTogether(screen_content))

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"Successfully generated {filename}")

if __name__ == "__main__":
    out_path = "c:\\flutter\\AGriYard_flutter-main\\AGriYard_flutter-main\\AgriYard_Presentation_Guide.pdf"
    build_pdf(out_path)
