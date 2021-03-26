# HACKATON_IIT_2021 Unified Ontology Challenge
## Ressources and references to be used for the challenge:

Here are the links to the different models/sources of information used to build the examples of graphs in this repository:

SAP Help on the domain Purchase Requisition
https://help.sap.com/viewer/bb9f1469daf04bd894ab2167f8132a1a/2011.500/en-US/43c43f584eff2160e10000000a44147b.html
 
The API in the SAP API Hub
https://api.sap.com/api/API_PURCHASEREQ_PROCESS_SRV/resource
 
ODM Business entity model:
https://api.sap.com/sap-one-domain-model
https://github.com/HACKATON-IIT-2021/unified-ontology/blob/main/ProcurementEntityModels/PurchaseRequisition.cds

Business Process workflow Source-To-Pay in BPMN:
https://github.com/HACKATON-IIT-2021/unified-ontology/blob/main/procurementToPay.bpmn
 
Actions:
VDM / RAP Modeling on BOs and BOS Behavior /Operations/ Actions for transactional Data.
https://help.sap.com/viewer/923180ddb98240829d935862025004d6/Cloud/en-US/a3ff9dcdb25a4f1a9408422b8ba5fa00.html

Ontology Design Patterns:
https://www.researchgate.net/publication/227215903_Ontology_Design_Patterns

https://schema.org/
 
## Evaluation query based on SPARQL on the graph:

1. Get possible actions, next step in the process and API Signature by Entity Name

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX proc: <http://www.semanticweb.org/i816674/ontologies/2021/1/untitled-ontology-14#>


SELECT 
?document 
?current_activity 
?next_document 
?action 
?document_item 
?request_name  
?api_signature
?api_body

WHERE {  

# current_activity = Assign_Source
?current_activity rdfs:subClassOf ?activity .
?activity owl:onProperty proc:operatesOnBusinessEntity .
?activity owl:someValuesFrom ?document .  

# next_document = ConvertPurchaseRequisitiontoPurchase_Order
?current_activity rdfs:subClassOf ?next_step .
?next_step owl:onProperty proc:isSucceededBy .
?next_step  owl:someValuesFrom ?next_document .
                 
# action = UpdatePurchaseRequisition
?document rdfs:subClassOf ?actions .
?actions owl:onProperty proc:hasOperation .
?actions owl:someValuesFrom ?action .

# request_name = UpdatePurchaseRequisitionItemOfPurchaseRequisition
?request_name rdfs:subClassOf ?requests .
?requests owl:onProperty proc:implementsBusinessOperation.
?requests owl:someValuesFrom ?action  .

# api_signature = Patch_API_PURCHASEREQ_PROCESS_SRV
?document owl:disjointWith ?document_item .
?document_item rdfs:subClassOf ?actions_item .
?actions_item owl:onProperty proc:isAFilterInBusinessServiceAPI .
?actions_item owl:someValuesFrom ?api_signature .

# api_body = APIBodyUpdatePurchaseRequisitionItemOfPurchaseRequisition
?api_body rdfs:subClassOf ?bodys .
?bodys owl:onProperty proc:isABodyInBusinessServiceAPI.
?bodys owl:someValuesFrom ?api_signature  .

}
```
2. Get possible actions, DocumentItem and Document Item Attributes by Entity Name

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX proc: <http://www.semanticweb.org/i816674/ontologies/2021/1/untitled-ontology-14#>

SELECT 
?document
?action
?document_item
?action_item_attributes

WHERE {  

# action = UpdatePurchaseRequisition                               
?document rdfs:subClassOf ?actions .
?actions owl:onProperty proc:hasOperation .
?actions owl:someValuesFrom ?action  .

# document_item = PurchaseRequisitionitem
# action_item_attributes = [plant, price, number, taxCode ... deliveryAddress] 
?document owl:disjointWith ?document_item .
?document_item rdfs:subClassOf ?actionsItem .
?actions_item owl:onProperty proc:hasBusinessAttribute.
?actions_item owl:allValuesFrom ?action_item_attributes 
}
```
