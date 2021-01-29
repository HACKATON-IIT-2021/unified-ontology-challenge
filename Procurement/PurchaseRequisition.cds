namespace sap.odm.procurement;

using {
  sap.odm.common.cuid,
  sap.odm.common.managed,
  sap.odm.common.CurrencyCode,
  sap.odm.common.LanguageCode,
  sap.odm.common.UnitOfMeasureCode,
  sap.odm.common.Amount,
  sap.odm.common.TimeZoneCode
} from '../common';
using {sap.odm.iam.User} from '../iam';
using {
  sap.odm.finance.accounting.AccountAssignmentCategoryCode,
  sap.odm.finance.accounting.PaymentTermsCode,
  sap.odm.finance.TaxCode,
  sap.odm.finance.TaxJurisdictionCode
} from '../finance';
using {
  sap.odm.orgunit.CompanyCode,
  sap.odm.orgunit.Plant
} from '../orgunit';
using {
  sap.odm.procurement.PurchaseContract,
  sap.odm.procurement.PurchaseContractItemReference,
  sap.odm.procurement.PurchaseRequisitionTypeCode,
  sap.odm.procurement.PurchaseDocumentItem,
  sap.odm.procurement.Quantity,
  sap.odm.procurement.PurchaseDocumentAddress,
  sap.odm.procurement.PurchaseRequisitionStatusCode,
  sap.odm.procurement.Supplier,
  sap.odm.procurement.orgunit.PurchasingOrganization,
  sap.odm.procurement.orgunit.PurchasingGroup
} from '.';

/**
 * A request or instruction to Purchasing to procure a quantity
 * of a material or service so that it is available at a
 * certain point in time.
 */
@ODM.root : true
entity PurchaseRequisition : cuid, managed {
  /**
   * Purchase requisition number.
   */
  displayId     : String(10);
  /**
   * Purchase requisition description, which is used as title of
   * the purchase requisition.
   */
  description   : String(256);
  /**
   * A note for the purchase requisition.
   */
  note          : String(5000);
  /**
   * User who prepares purchase requisition. Required for Ariba.
   */
  preparer      : Association to one User;
  /**
   * Version of purchase requisition. Required for Ariba.
   */
  version       : String(10);
  /**
   * Status of purchase requisition. Required for Ariba.
   */
  status        : PurchaseRequisitionStatusCode;
  /**
   * Source Logical system.
   */
  logicalSystem : String(50);
  /**
   * Purchase requisition line items.
   */
  items         : Composition of many PurchaseRequisitionItem
                    on items.parent = $self;
}

/**
 * Purchase requisition line item.
 */
entity PurchaseRequisitionItem : managed, PurchaseDocumentItem {
      /**
       * Requisition this item belongs to.
       */
  key parent                    : Association to one PurchaseRequisition;
      /**
       * Item number in the purchase requisition.
       */
  key number                    : String(10);
      /**
       * A note for the line item of purchase requisition.
       */
      note                      : String(5000);
      /**
       * Reference to the line item of purchasing contract.
       */
      purchaseContractItem      : PurchaseContractItemReference;
      /**
       * Business partner who offers or provides materials or
       * services.
       */
      supplier                  : Association to one Supplier;
      /**
       * The unique identifier of the supplier location for the
       * purchase requisition.
       */
      supplierLocation          : String(50);
      /**
       * Payment Terms.
       */
      paymentTerms              : PaymentTermsCode;
      /**
       * Plant of the item.
       */
      plant                     : Association to one Plant;
      /**
       * Company Code associated with the purchase requisition.
       */
      companyCode               : Association to one CompanyCode;
      /**
       * Purchasing group. Key for a buyer or a group of buyers, who
       * is/are responsible for certain purchasing activities.
       */
      purchasingGroup           : Association to one PurchasingGroup;
      /**
       * Purchasing Organization. Denotes the purchasing
       * organization.
       */
      purchasingOrganization    : Association to one PurchasingOrganization;
      /**
       * Purchase Requisition type.
       */
      type                      : PurchaseRequisitionTypeCode;
      /**
       * Price in purchase requisition.
       */
      price                     : Amount;
      /**
       * The tax code represents a tax category which must be taken
       * into consideration when making a tax return to the tax
       * authorities. Tax codes are unique per country.
       */
      taxCode                   : TaxCode;
      /**
       * The tax jurisdiction is used for determining the tax rates
       * in the USA. It defines to which tax authorities you must pay
       * your taxes. It is always the city to which the goods are
       * supplied.
       */
      taxJurisdiction           : TaxJurisdictionCode;
      /**
       * Tax amount per Unit.
       */
      taxAmountPerUnit          : Amount;
      /**
       * Delivery address.
       */
      deliveryAddress           : PurchaseDocumentAddress;
      /**
       * Account Assignment Category.
       */
      accountAssignmentCategory : AccountAssignmentCategoryCode;
      /**
       * Requested delivery date and time.
       */
      deliveryAt                : DateTime;
      /**
       * Requested line delivery time zone.
       */
      deliveryTimeZone          : TimeZoneCode; // TODO: Remove in case of confirmation DateTime contains time zone, too
}
