# -- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2010-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
# ++

require 'spec_helper'

RSpec.describe Queries::Projects::ProjectQuery do
  let(:instance) { described_class.new }

  shared_let(:current_user) { create(:user) }

  context 'when persisting' do
    let(:properties) do
      {
        name: 'some name',
        user: current_user
      }
    end

    it 'takes a name property' do
      instance = described_class.create(**properties)

      expect(described_class.find(instance.id).name)
        .to eql properties[:name]
    end

    it 'takes a user property' do
      instance = described_class.create(**properties)

      expect(described_class.find(instance.id).user)
        .to eql properties[:user]
    end

    it 'takes filters' do
      instance = described_class.new(**properties)

      instance.where('active', '=', OpenProject::Database::DB_VALUE_TRUE)

      instance.save!

      expect(described_class.find(instance.id).filters.map { |f| { field: f.field, operator: f.operator, values: f.values } })
        .to eql [{ field: :active, operator: '=', values: [OpenProject::Database::DB_VALUE_TRUE] }]
    end

    it 'takes sort order' do
      instance = described_class.new(**properties)

      instance.order(id: :desc)

      instance.save!

      expect(described_class.find(instance.id).orders.map { |o| { o.attribute => o.direction } })
        .to eql [{ id: :desc }]
    end
  end
end
