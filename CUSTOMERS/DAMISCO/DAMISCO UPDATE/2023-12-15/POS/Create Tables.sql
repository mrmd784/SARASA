

--drop table HavelockSalesData

CREATE TABLE HavelockSalesData(
   idx						bigint  NOT NULL PRIMARY KEY IDENTITY(1,1)
  ,cashierId                VARCHAR(50) NOT NULL
  ,customerMobileNo         VARCHAR(15) NOT NULL
  ,invoiceType              VARCHAR(12) NOT NULL
  ,invoiceNo                VARCHAR(50) NOT NULL
  ,invoiceDate              datetime NOT NULL
  ,currencyCode             VARCHAR(3) NOT NULL
  ,currencyRate             DECIMAL(8,4)  NOT NULL
  ,totalInvoice             DECIMAL(15,4)  NOT NULL
  ,totalTax                 DECIMAL(15,4) NOT NULL
  ,totalDiscount            DECIMAL(15,4)  NOT NULL
  ,totalGiftVoucherSale     DECIMAL(15,4)  NOT NULL
  ,totalGiftVoucherTax      DECIMAL(15,4) NOT NULL
  ,totalGiftVoucherDiscount DECIMAL(15,4)  NOT NULL
  ,paidByCash               DECIMAL(15,4)  NOT NULL
  ,paidByCard               DECIMAL(15,4)  NOT NULL
  ,cardBank                 VARCHAR(5)  NOT NULL
  ,cardCategory             VARCHAR(6) NOT NULL
  ,cardType                 VARCHAR(10) NOT NULL
  ,GiftVoucherBurn          DECIMAL(15,4)  NOT NULL
  ,hcmLoyalty               DECIMAL(15,4)  NOT NULL
  ,tenantLoyalty            DECIMAL(15,4)  NOT NULL
  ,creditNotes              DECIMAL(15,4)  NOT NULL
  ,otherPayments            DECIMAL(15,4)  NOT NULL
  ,DataTransfer             BIT  NOT NULL
  ,TransferDate				Datetime NULL
);
go

--drop table HavelockSalesDatabackup
CREATE TABLE HavelockSalesDataBackup(
   idx						bigint  NOT NULL PRIMARY KEY IDENTITY(1,1)
  ,cashierId                VARCHAR(50) NOT NULL
  ,customerMobileNo         VARCHAR(15) NOT NULL
  ,invoiceType              VARCHAR(12) NOT NULL
  ,invoiceNo                VARCHAR(50) NOT NULL
  ,invoiceDate              datetime NOT NULL
  ,currencyCode             VARCHAR(3) NOT NULL
  ,currencyRate             DECIMAL(8,4)  NOT NULL
  ,totalInvoice             DECIMAL(15,4)  NOT NULL
  ,totalTax                 DECIMAL(15,4) NOT NULL
  ,totalDiscount            DECIMAL(15,4)  NOT NULL
  ,totalGiftVoucherSale     DECIMAL(15,4)  NOT NULL
  ,totalGiftVoucherTax      DECIMAL(15,4) NOT NULL
  ,totalGiftVoucherDiscount DECIMAL(15,4)  NOT NULL
  ,paidByCash               DECIMAL(15,4)  NOT NULL
  ,paidByCard               DECIMAL(15,4)  NOT NULL
  ,cardBank                 VARCHAR(5)  NOT NULL
  ,cardCategory             VARCHAR(6) NOT NULL
  ,cardType                 VARCHAR(10) NOT NULL
  ,GiftVoucherBurn          DECIMAL(15,4)  NOT NULL
  ,hcmLoyalty               DECIMAL(15,4)  NOT NULL
  ,tenantLoyalty            DECIMAL(15,4)  NOT NULL
  ,creditNotes              DECIMAL(15,4)  NOT NULL
  ,otherPayments            DECIMAL(15,4)  NOT NULL
  ,DataTransfer             BIT  NOT NULL
  ,TransferDate				Datetime NULL
);
go