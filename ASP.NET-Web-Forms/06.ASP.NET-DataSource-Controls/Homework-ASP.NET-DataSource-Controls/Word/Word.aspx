﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Word.aspx.cs" Inherits="Word.Word" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <p><strong>Notice that not all continents and countries have added info in DB.</strong></p>
    <form id="formWord" runat="server">
        <%-- Continents --%>
        <asp:EntityDataSource ID="EntityDataSourceContinents" runat="server"
            OnContextCreating="WordContextEntityDataSource_ContextCreating"
            ContextTypeName="Word.Data.WordContext"
            ConnectionString="name=WordDBContext"
            DefaultContainerName="WordContext"
            EntitySetName="Continents"
            EnableFlattening="false" />

        <h2>Continents</h2>
        <p>Double click to select continent(Europe or North America).</p>
        <asp:ListBox
            ID="ListBoxContinents"
            runat="server"
            AutoPostBack="true"
            DataSourceID="EntityDataSourceContinents"
            DataTextField="Name"
            DataValueField="Id"
            OnSelectedIndexChanged="ListBoxContinents_SelectedIndexChanged" 
            Height="150"></asp:ListBox>

        <asp:FormView
            ID="FormViewContinent"
            runat="server"
            DataSourceID="EntityDataSourceContinents"
            ItemType="Word.Model.Continent"
            DataKeyNames="Id">
            <ItemTemplate>
                Continent Name: <%#: Item.Name %>
                <br />
                Number of countries: <%#: Item.Countries.Count %>
                <br />
            </ItemTemplate>
        </asp:FormView>

        <%-- Countries --%>
        <asp:EntityDataSource ID="EntityDataSourceCountries" runat="server"
            OnContextCreating="WordContextEntityDataSource_ContextCreating"
            ContextTypeName="Word.Data.WordContext"
            ConnectionString="name=WordDBContext"
            DefaultContainerName="WordContext"
            EntitySetName="Countries"
            EnableDelete="true"
            EnableUpdate="true"
            EnableInsert="true"
            EnableFlattening="false" 
            Where="it.Continent.Id=@ContinentID">
            <WhereParameters>
                <asp:ControlParameter Name="ContinentID" Type="Int32" ControlID="ListBoxContinents" />
            </WhereParameters>
        </asp:EntityDataSource>

        <h2>Countries</h2>
        <p>You can find sample flags in ~/Word/Flags.</p>
        <asp:GridView
            runat="server"
            ID="GridViewCountries"
            DataSourceID="EntityDataSourceCountries"
            AutoGenerateColumns="false"
            DataKeyNames="Id"
            AllowPaging="true"
            AllowSorting="true"
            AutoGenerateEditButton="true"
            AutoGenerateDeleteButton="true"
            OnRowCommand="GridViewCountries_RowCommand">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton Text="Select" runat="server" ID="LinkButtonSelectTown" CommandName="Select" CommandArgument='<%# Eval("Id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Name" HeaderText="Country name" SortExpression="Name" />
                <asp:BoundField DataField="Population" HeaderText="Population" SortExpression="Population" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <img src='<%#: getImage((byte[])Eval("Flag")) %>' alt="<%#: Eval("Name") + " flag" %>" width="100" height="50" style="border:1px solid black;" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:FileUpload runat="server" ID="FileUploadFlag" />
                        <asp:Button ID="ButtonAddFlag" CommandArgument='<%#Bind("Id") %>' CommandName="Upload" runat="server" Text="Add or Update Flag" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <%-- Towns --%>
        <asp:EntityDataSource ID="EntityDataSourceTowns" runat="server"
            OnContextCreating="WordContextEntityDataSource_ContextCreating"
            ContextTypeName="Word.Data.WordContext"
            ConnectionString="name=WordDBContext"
            DefaultContainerName="WordContext"
            EntitySetName="Towns"
            EnableDelete="True"
            EnableUpdate="True"
            EnableInsert="True"
            EnableFlattening="false" 
            Where="it.Country.Id=@CountryID">
            <WhereParameters>
                <asp:ControlParameter Name="CountryID" Type="Int32" ControlID="GridViewCountries" DefaultValue="0" PropertyName="SelectedValue" />
            </WhereParameters>
        </asp:EntityDataSource>

        <asp:ListView
            runat="server"
            DataSourceID="EntityDataSourceTowns"
            ID="ListViewTowns"
            ItemType="Word.Model.Town"
            DataKeyNames="Id"
            InsertItemPosition="None"
            OnItemInserted="ListViewTowns_ItemInserted">

            <LayoutTemplate>
                <h2>Towns</h2>
                <span runat="server" id="itemPlaceholder" />
                <div class="pagerLine">
                    <asp:Button ID="ButtonInsertTown" Text="Insert" runat="server" OnClick="ButtonInsertTown_Click" />
                    |
                    <asp:DataPager ID="DataPagerCustomers" runat="server" PageSize="4">
                        <Fields>
                            <asp:NextPreviousPagerField ShowFirstPageButton="True"
                                ShowNextPageButton="False" ShowPreviousPageButton="False" />
                            <asp:NumericPagerField />
                            <asp:NextPreviousPagerField ShowLastPageButton="True"
                                ShowNextPageButton="False" ShowPreviousPageButton="False" />
                        </Fields>
                    </asp:DataPager>
                </div>
            </LayoutTemplate>

            <ItemTemplate>
                <div>
                    Name: <%#: Item.Name %>
                    <br />
                    Population: <%#: Item.Population %>
                </div>
                <asp:Button ID="ButtonEdit" runat="server" CommandName="Edit" Text="Edit" />
                <asp:Button ID="ButtonDelete" runat="server" CommandName="Delete" Text="Delete" />
                <hr />
            </ItemTemplate>

            <EditItemTemplate>
                Name: <%#: Item.Name %>
                <br />
                Population:
                <asp:TextBox ID="TextBoxPopulation" runat="server" Text="<%#: BindItem.Population %>" />
                
                <asp:Button ID="ButtonUpdate" runat="server" CommandName="Update" Text="Update" />
                <asp:Button ID="ButtonCancel" runat="server" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>

            <InsertItemTemplate>
                Name: 
                <asp:TextBox ID="TextBoxTownName" runat="server" Text='<%# Bind("Name") %>' />
                <br />
                Population:
                <asp:TextBox ID="TextBoxPopulation" runat="server" Text='<%# Bind("Population") %>' />
                <asp:Button ID="ButtonInsert" runat="server" CommandName="Insert" Text="Insert" />
                <asp:Button ID="ButtonCancel" runat="server" CommandName="Cancel" Text="Clear" />
            </InsertItemTemplate>

        </asp:ListView>

        <asp:Label Text="" ID="LabelContinent" runat="server" />
    </form>
</body>
</html>